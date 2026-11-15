extends VBoxContainer

@onready var carta_display: PanelContainer = $CartaDisplay
@onready var cartas_contenedor: GridContainer = $ScrollContainer/Cartas
const CARTA_BUTTON_ENTRADA = preload("res://Cartas/CartaButtonEntrada.tscn")
const CARTA = preload("res://Cartas/carta.tscn")
var cartas_ids: Array
var carta_actual_id: String
const CreacionEdicionCarta = preload("res://Cartas/creacion_edicion_carta.tscn")
const COMPENDIO_VISUAL = preload("res://Cartas/compendio_visual.tscn")

@onready var eliminar_button: Button = $HBoxContainer/EliminarButton
@onready var editar_button: Button = $HBoxContainer/EditarButton

@onready var dinero_LE: LineEdit = $HBoxContainer2/Control2/Dinero
var dinero: int 
var temp: Timer
@onready var hoja_personaje: Control = $"../../../.."

func mostrar_cartas():
	cartas_ids = hoja_personaje.personaje.cartas_equipadas
	
	for hijo in cartas_contenedor.get_children():
		hijo.queue_free()
		
	if cartas_ids.is_empty():
		var label_vacio := Label.new()
		label_vacio.text = "No se encontraron cartas"
		label_vacio.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cartas_contenedor.add_child(label_vacio)
		return
		
	# 3. Mostramos las cartas filtradas
	for carta_id in cartas_ids:
		var carta = CompendioCartas.obtener_carta(carta_id)
		var cartaUI = CARTA_BUTTON_ENTRADA.instantiate()
		cartaUI.id = carta["id"]
		cartaUI.text = carta["titulo"]
		cartaUI.comprada = false
		
		cartaUI.seleccionar.connect(_on_carta_seleccionada)
		cartas_contenedor.add_child(cartaUI)
		
func setup():
	dinero = hoja_personaje.personaje.dinero
	dinero_LE.text = str(dinero)
	mostrar_cartas()
	

func _on_carta_seleccionada(id_carta: String, _comprada: bool = false):
	if carta_actual_id == id_carta:
		for cv in carta_display.get_children():
			cv.queue_free()
		editar_button.disabled = true
		eliminar_button.disabled = true
		carta_actual_id = ""
		return
	else:
		editar_button.disabled = false
		eliminar_button.disabled = false
		carta_actual_id = id_carta
		
		for cv in carta_display.get_children():
			cv.queue_free()
			
		var datos_carta = CompendioCartas.obtener_carta(id_carta)
		if datos_carta.is_empty(): return
			
		var carta_visual_inst = CARTA.instantiate()
		carta_display.add_child(carta_visual_inst)
		carta_visual_inst.cargar_visuales(datos_carta)

func _ready() -> void:
	await hoja_personaje.ready
	temp = Timer.new()
	temp.wait_time = 5.0
	temp.one_shot = true
	add_child(temp)
	temp.timeout.connect(_on_temp_timeout)
	setup()
	

func _negar_escritura(line_edit: LineEdit):
	var posicion_cursor = line_edit.caret_column
	line_edit.text = line_edit.text.substr(0, posicion_cursor - 1) + line_edit.text.substr(posicion_cursor)
	line_edit.caret_column = posicion_cursor - 1
	return
		
func _filtrar_solo_numeros(line_edit: LineEdit, new_text: String) -> void:
	# Comprobamos si el texto es un número válido
	if not new_text.is_valid_int():
		_negar_escritura(line_edit)
		
func _on_dinero_text_changed(new_text: String) -> void:
	if new_text == "":
		return
	_filtrar_solo_numeros(dinero_LE,new_text)
	dinero = int(new_text)
	dinero = clampi(dinero,0,1000000)
	hoja_personaje.personaje.dinero = dinero
	GestorPersonaje.guardar_personaje(hoja_personaje.personaje,hoja_personaje.personaje_id)

func _on_dinero_focus_entered() -> void:
	temp.start()
	
func _on_temp_timeout():
	dinero_LE.release_focus()

func _on_eliminar_button_pressed() -> void:
	if carta_actual_id == "":
		return
		
	var dialogo := ConfirmationDialog.new()
	dialogo.title = "Eliminar Carta"
	dialogo.dialog_text = "¿Estás seguro de que quieres eliminar esta carta?"
	dialogo.theme = load("res://Assets/tema_claro.tres")
	dialogo.get_ok_button().focus_mode = Control.FOCUS_NONE
	add_child(dialogo)
	
	dialogo.confirmed.connect(func():
		var costo = CompendioCartas.obtener_carta(carta_actual_id)["costo"]
		for bono in costo.keys():
			if bono == "dinero":
				continue
			var actual = hoja_personaje.personaje.get(bono)
			hoja_personaje.personaje.set(bono,actual+costo[bono])
		GestorPersonaje.guardar_personaje(hoja_personaje.personaje,hoja_personaje.personaje_id)
		GestorPersonaje.quitar_carta(hoja_personaje.personaje_id, carta_actual_id)
		cartas_ids.erase(carta_actual_id)
		
		# 4. Refrescar la UI
		carta_actual_id = ""
		mostrar_cartas()
		
		dialogo.queue_free()
	)
	dialogo.canceled.connect(func(): dialogo.queue_free())
	dialogo.popup_centered(Vector2i(400, 200))

func _on_editar_button_pressed() -> void:
	var CEC := CreacionEdicionCarta.instantiate()
	CEC.carta_actual_id = carta_actual_id
	get_tree().change_scene_to_node(CEC)


func _on_anadir_button_pressed() -> void:
	var CV := COMPENDIO_VISUAL.instantiate()
	CV.id_personaje = hoja_personaje.personaje_id
	get_tree().change_scene_to_node(CV)
