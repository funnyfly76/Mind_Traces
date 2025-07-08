extends Area3D

@onready var label: Label3D = $Label3D
@onready var mesh: MeshInstance3D = $MeshInstance3D

# Материалы
var default_material: StandardMaterial3D
var highlight_material: StandardMaterial3D

# Настройки
@export var interaction_text: String = "Нажмите [E]"

func _ready():
	# Добавляем в группу для взаимодействия
	add_to_group("interactable")
	
	# Настройка текста
	label.text = interaction_text
	label.visible = false
	
	# Создание материалов
	_create_materials()

func _create_materials():
	# Создаем материал если не существует
	if not mesh.material_override:
		var new_mat = StandardMaterial3D.new()
		new_mat.albedo_color = Color(0.8, 0.8, 0.8)
		mesh.material_override = new_mat
	
	# Копируем материалы
	default_material = mesh.material_override.duplicate()
	highlight_material = default_material.duplicate()
	
	# Настройка подсветки
	highlight_material.emission_enabled = true
	highlight_material.emission = Color(0.2, 0.7, 1.0)
	highlight_material.emission_energy_multiplier = 0.8

func set_highlight(enable: bool):
	if enable:
		mesh.material_override = highlight_material
		label.visible = true
	else:
		mesh.material_override = default_material
		label.visible = false

func interact():
	print("Interaction with: ", name)
	
	# Простая анимация
	var tween = create_tween()
	tween.tween_property(mesh, "scale", Vector3(1.2, 1.2, 1.2), 0.1)
	tween.tween_property(mesh, "scale", Vector3.ONE, 0.1)
