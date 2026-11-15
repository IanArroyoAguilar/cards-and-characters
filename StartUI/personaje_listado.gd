extends Control

@onready var nombre: Label = $HBoxContainer/Nombre
@onready var seleccionar_button: Button = $HBoxContainer/SeleccionarButton
@onready var editar_button: TextureButton = $HBoxContainer/EditarButton
@onready var delete_button: TextureButton = $HBoxContainer/DeleteButton

@onready var id: String

signal seleccionado(id:String)

@onready var panel_principal = get_tree().current_scene.get_node("PanelPersonajes") # O una ruta específica

func setup(nombre_enviado,id_enviada):
	nombre.text = nombre_enviado
	id = id_enviada
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _on_seleccionar_button_pressed() -> void:
	emit_signal("seleccionado",id)

func _on_editar_button_pressed() -> void:
	print("editar: "+nombre.text)


func _on_delete_button_pressed() -> void:
	var dialogo := ConfirmationDialog.new()
	dialogo.title = ""
	dialogo.dialog_text = "¿Estás seguro de que quieres eliminar a %s?\nEsta acción no se puede deshacer." % nombre.text
	dialogo.theme = load("res://Assets/tema_claro.tres")
	dialogo.get_label().horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dialogo.get_label().add_theme_font_size_override("font_size", 20)
	dialogo.get_ok_button().focus_mode = Control.FOCUS_NONE
	add_child(dialogo)

	# --- AQUÍ ESTÁ EL CAMBIO ---
	# Conectamos a funciones normales, y le pasamos el diálogo como "extra"
	dialogo.confirmed.connect(_al_confirmar_eliminar.bind(dialogo))
	dialogo.canceled.connect(_al_cancelar_eliminar.bind(dialogo))

	dialogo.popup_centered(Vector2i(400, 200))

	# Nueva función para cuando confirman
func _al_confirmar_eliminar(dialogo: ConfirmationDialog) -> void:
	GestorPersonaje.eliminar_personaje(id)

	if is_instance_valid(panel_principal):
		panel_principal.refrescar_lista()
		
	dialogo.queue_free()


# Nueva función para cuando cancelan
func _al_cancelar_eliminar(dialogo: ConfirmationDialog) -> void:
	dialogo.queue_free()
