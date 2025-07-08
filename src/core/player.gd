extends CharacterBody3D

# Настройки движения
@export var mouse_sensitivity: float = 0.002
@export var move_speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var gravity: float = 9.8
@export var interaction_distance: float = 3.0

# Ссылки на ноды
@onready var camera: Camera3D = $MainCamera
@onready var interaction_ray: RayCast3D = $MainCamera/InteractionRay

# Переменные взаимодействия
var current_interactable: Area3D = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Настройка RayCast
	interaction_ray.enabled = true
	interaction_ray.target_position = Vector3(0, 0, -interaction_distance)
	interaction_ray.collide_with_areas = true
	interaction_ray.collide_with_bodies = false

func _input(event):
	# Вращение камеры
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	# Обработка взаимодействия
	if event.is_action_pressed("interact") and current_interactable:
		current_interactable.interact()

func _physics_process(delta):
	# Гравитация
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Прыжок
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Движение WASD
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	move_and_slide()

func _process(_delta):
	_update_interaction_target()

func _update_interaction_target():
	interaction_ray.force_raycast_update()
	
	if interaction_ray.is_colliding():
		var new_target = interaction_ray.get_collider()
		
		if new_target != current_interactable:
			_clear_highlight(current_interactable)
			
			if new_target is Area3D and new_target.is_in_group("interactable"):
				current_interactable = new_target
				_set_highlight(current_interactable)
	else:
		_clear_highlight(current_interactable)
		current_interactable = null

func _set_highlight(target: Area3D):
	if target and target.has_method("set_highlight"):
		target.set_highlight(true)

func _clear_highlight(target: Area3D):
	if target and target.has_method("set_highlight"):
		target.set_highlight(false)
