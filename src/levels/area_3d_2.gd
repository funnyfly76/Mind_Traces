extends Area3D  # Или Interactable, если вы используете базовый класс

@export var interaction_text: String = "Нажмите [E]"  # Добавьте эту строку

@onready var label: Label3D = $Label3D
@onready var mesh: MeshInstance3D = $MeshInstance3D

var default_material: StandardMaterial3D
var highlight_material: StandardMaterial3D

func _ready():
	# Убедимся что меш существует
	if not mesh:
		push_error("MeshInstance3D not found!")
		return
	
	# Создаем материалы если их нет
	if mesh.material_override == null:
		mesh.material_override = StandardMaterial3D.new()
	
	# Инициализация материалов
	default_material = mesh.material_override.duplicate()
	highlight_material = default_material.duplicate()
	
	# Настройка подсвеченного материала
	highlight_material.emission_enabled = true
	highlight_material.emission = Color(0.2, 0.7, 1.0)
	highlight_material.emission_energy_multiplier = 0.8
	
	# Настройка текста
	if label:
		label.text = interaction_text  # Теперь переменная определена
		label.visible = false

func set_highlight(enable: bool):
	if not mesh: return
	
	if enable:
		mesh.material_override = highlight_material
		if label: label.visible = true
	else:
		mesh.material_override = default_material
		if label: label.visible = false

func interact():
	# Анимация для демонстрации
	var tween = create_tween()
	tween.tween_property(mesh, "scale", Vector3(1.2, 1.2, 1.2), 0.1)
	tween.tween_property(mesh, "scale", Vector3.ONE, 0.1)
	
	# Вызов сигнала взаимодействия
	# emit_signal("interacted")  # Раскомментируйте если используете сигналы
