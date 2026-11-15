extends Control
@export var personaje_id: String
@onready var personaje: Personaje = GestorPersonaje.cargar_personaje(personaje_id)

# info
@onready var nombre_label: Label = $PanelContainer/HBoxContainer/Central/PaneNombre/HBoxContainer/NombreLabel
@onready var raza_label: Label = $PanelContainer/HBoxContainer/Central/PaneNombre/HBoxContainer/RazaLabel
@onready var nivel: Label = $PanelContainer/HBoxContainer/Central/PaneNombre/HBoxContainer/Nivel
const SUBIR_NIVEL_INTERFAZ = preload("res://PersonajeLogic/HojaPersonaje/subir_nivel_interfaz.tscn")

func setup():
	nombre_label.text = personaje.nombre
	raza_label.text = personaje.raza
	nivel.text = str(personaje.nivel)
	
func _ready() -> void:
	setup()


func _on_atras_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func _on_subir_nivel_button_pressed() -> void:
	var SN = SUBIR_NIVEL_INTERFAZ.instantiate()
	SN.personaje_id = personaje_id
	get_tree().change_scene_to_node(SN)
