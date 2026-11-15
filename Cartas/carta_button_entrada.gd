extends Button

@export var id: String = ""
@export var comprada: bool = false

signal seleccionar(id: String) 
signal comprar(id: String)

func _gui_input(event: InputEvent) -> void:
	# 1. Detectar un solo toque/clic para mostrar la carta
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Si NO es un doble clic, mostramos la carta
		if not event.double_click:
			emit_signal("seleccionar", id, comprada)
		else:
			# 2. Si ES un doble clic, compramos la carta
			emit_signal("comprar", id)
			# Aceptamos el evento para que no se propague
			accept_event()
			
	# (Opcional para móvil táctil puro, aunque Godot suele emular el ratón)
	elif event is InputEventScreenTouch and event.pressed:
		if event.double_tap:
			emit_signal("comprar", id)
			accept_event()
