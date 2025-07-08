class_name Interactable
extends Area3D

# Сигнал при взаимодействии
signal interacted

# Настройки (экспортируемые)
@export var interaction_text: String = "Нажмите [E]"
@export var highlight_color: Color = Color(0.2, 0.7, 1.0)

# Виртуальные методы для переопределения
func interact():
	emit_signal("interacted")
	print("Interacted with: ", name)

func set_highlight(enable: bool):
	pass
