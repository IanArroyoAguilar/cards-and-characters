extends Control

# Referencias a nodos (se resuelven al cargar la escena)
@onready var lista_personajes: VBoxContainer = $MarginContainer/VBoxContainer/PanelLista/VBoxContainer/ScrollContainer/ListaPersonajes
@onready var boton_crear: TextureButton = $MarginContainer/VBoxContainer/PanelLista/VBoxContainer/CabeceraLista/ButtonCrear

@onready var ESCENA_FILA := preload("res://StartUI/personaje_listado.tscn")
const HOJA_PERSONAJE = preload("res://PersonajeLogic/HojaPersonaje/hoja_personaje.tscn")


func put_basse_buttons():
	var button_cartas = $MarginContainer/VBoxContainer/Sup/BarraSuperior/ButtonCartas
	button_cartas.pressed.connect(_on_cartas_pressed)
	
	var button_libro = $MarginContainer/VBoxContainer/Sup/BarraSuperior/ButtonLibro
	button_libro.pressed.connect(_on_libro_pressed)
	
	var button_ajustes = $MarginContainer/VBoxContainer/Sup/BarraSuperior/ButtonAjustes
	button_ajustes.pressed.connect(_on_ajustes_pressed)
	
	var button_salir = $MarginContainer/VBoxContainer/Sup/BarraSuperior/ButtonSalir
	button_salir.pressed.connect(_on_salir_pressed)
	
	# Botón crear
	boton_crear.pressed.connect(_on_crear_personaje)
	
func _ready() -> void:
	put_basse_buttons()

	refrescar_lista()

# Reconstruye la lista visual desde disco
func refrescar_lista() -> void:
	for hijo in lista_personajes.get_children():
		hijo.queue_free()

	var ids = GestorPersonaje.listar_personajes()

	if ids.is_empty():
		var label := Label.new()
		label.text = "No hay personajes todavía. ¡Crea uno!"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lista_personajes.add_child(label)
		return

	for id in ids:
		var personaje: Personaje = GestorPersonaje.cargar_personaje(id)
		if personaje == null:
			continue
		_crear_fila(id, personaje)
		
# Crea una fila visual para un personaje
func _crear_fila(id: String, personaje: Personaje) -> void:
	var fila = ESCENA_FILA.instantiate()
	fila.seleccionado.connect(_on_personaje_seleccionado)
	lista_personajes.add_child(fila)
	fila.setup(personaje.nombre,id)

func _on_personaje_seleccionado(id: String):
	var HP = HOJA_PERSONAJE.instantiate()
	HP.personaje_id = id
	get_tree().change_scene_to_node(HP)

func _on_crear_personaje() -> void:
	print("TODO: abrir pantalla de creación de personaje")

func _on_cartas_pressed() -> void:
	get_tree().change_scene_to_file("res://Cartas/compendio_visual.tscn")

func _on_libro_pressed() -> void:
	print("TODO: abrir reglas y tutorial")

func _on_ajustes_pressed() -> void:
	print("TODO: abrir opciones")

func _on_salir_pressed() -> void:
	var dialogo := ConfirmationDialog.new()
	dialogo.dialog_text = "¿Seguro que quieres salir?"
	dialogo.title = ""
	dialogo.theme = load("res://Assets/tema_claro.tres")
	
	# Quitar el foco del botón OK para evitar el recuadro blanco
	dialogo.get_ok_button().focus_mode = Control.FOCUS_NONE
	dialogo.get_cancel_button().focus_mode = Control.FOCUS_NONE
	add_child(dialogo)
	dialogo.confirmed.connect(func():
		get_tree().quit()
		dialogo.queue_free()
	)
	dialogo.canceled.connect(func(): dialogo.queue_free())
	dialogo.popup_centered()
