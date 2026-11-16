extends Node

func _ready() -> void:
	GestorCarta.sincronizar_todo_con_json()
	
func _on_button_crear_pressed() -> void:
	get_tree().change_scene_to_file("res://PersonajeLogic/CreacionPersonaje/creacion_personaje.tscn")
