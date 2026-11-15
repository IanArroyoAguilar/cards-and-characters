extends Control

const CreacionEdicionCarta = preload("res://Cartas/creacion_edicion_carta.tscn")
@onready var cartas_contenedor: GridContainer = $PanelContainer/VSplitContainer/ScrollContainer/Cartas
const carta_button_scene = preload("res://Cartas/CartaButtonEntrada.tscn")
const carta_visual = preload("res://Cartas/carta.tscn")
var cartas_filtradas: Dictionary = CompendioCartas.todas_las_cartas 
@onready var carta_display: PanelContainer = $PanelContainer/VSplitContainer/PanelFiltros/FiltrosDisplay/CartaDisplay
var carta_actual_id: String = "" # Guarda la ID de la carta que se está viendo
@onready var editar_carta_button: Button = $PanelContainer/VSplitContainer/HBoxContainer/EditarCartaButton
@onready var eliminar_carta_button: Button = $PanelContainer/VSplitContainer/HBoxContainer/EliminarCartaButton
@onready var crear_carta_button: Button = $PanelContainer/VSplitContainer/HBoxContainer/CrearCartaButton
@onready var cantidad_label: Label = $PanelContainer/VSplitContainer/HBoxContainer/CantidadLabel

# Filtros booleanos:
@onready var unica_cb: CheckBox = $PanelContainer/VSplitContainer/PanelFiltros/FiltrosDisplay/Filtros/HBoxContainer/FiltrosDerecha/UnicaCB
# Seleccionables:
@onready var tipo_selector: OptionButton = $PanelContainer/VSplitContainer/PanelFiltros/FiltrosDisplay/Filtros/HBoxContainer/FiltrosIzquierda/TipoBox/TipoSelector
@onready var subtipo_selector: OptionButton = $PanelContainer/VSplitContainer/PanelFiltros/FiltrosDisplay/Filtros/HBoxContainer/FiltrosIzquierda/SubtipoBox/SubtipoSelector
@onready var costo_selector: OptionButton = $PanelContainer/VSplitContainer/PanelFiltros/FiltrosDisplay/Filtros/HBoxContainer/FiltrosIzquierda/CostoBox/CostoSelector
@onready var atributo_selector: OptionButton = $PanelContainer/VSplitContainer/PanelFiltros/FiltrosDisplay/Filtros/HBoxContainer/FiltrosDerecha/ModAtributoBox/AtributoSelector
# Busqueda:
@onready var busqueda: LineEdit = $PanelContainer/VSplitContainer/PanelFiltros/FiltrosDisplay/FiltrosBusqueda/HBoxContainer2/LineEdit
@onready var id_check_box: CheckBox = $PanelContainer/VSplitContainer/PanelFiltros/FiltrosDisplay/FiltrosBusqueda/HBoxContainer/idCheckBox
@onready var titulo_check_box: CheckBox = $PanelContainer/VSplitContainer/PanelFiltros/FiltrosDisplay/FiltrosBusqueda/HBoxContainer/tituloCheckBox

var HOJA_PERSONAJE = load("res://PersonajeLogic/HojaPersonaje/hoja_personaje.tscn")
var id_personaje: String = ""

func check_viene_personaje():
	if id_personaje != "":
		eliminar_carta_button.visible = false
		editar_carta_button.visible = false
		crear_carta_button.visible = false
		
		var h_box_container: HBoxContainer = $PanelContainer/VSplitContainer/HBoxContainer
		var seleccionar_button = Button.new()
		seleccionar_button.text = "Seleccionar"
		h_box_container.add_child(seleccionar_button)
		seleccionar_button.pressed.connect(_on_seleccionar_button_pressed)
		
func _on_seleccionar_button_pressed() -> void:
	var dialogo := ConfirmationDialog.new()
	dialogo.title = ""
	dialogo.dialog_text = "¿Estás seguro de que quieres seleccionar esa carta?"
	dialogo.theme = load("res://Assets/tema_claro.tres")
	
	# Quitar el foco del botón OK para evitar el recuadro blanco
	dialogo.get_ok_button().focus_mode = Control.FOCUS_NONE
	dialogo.get_cancel_button().focus_mode = Control.FOCUS_NONE
	
	add_child(dialogo)
	
	# 2. Conectamos las señales usando .bind() para pasarle el diálogo
	dialogo.confirmed.connect(_al_confirmar_seleccion.bind(dialogo))
	dialogo.canceled.connect(_al_cancelar.bind(dialogo))
	
	dialogo.popup_centered(Vector2i(400, 200))

func _al_confirmar_seleccion(_dialogo: ConfirmationDialog) -> void:
	var personaje = GestorPersonaje.cargar_personaje(id_personaje)
	personaje.cartas_equipadas.append(carta_actual_id)
	GestorPersonaje.guardar_personaje(personaje,id_personaje)
	var HP = HOJA_PERSONAJE.instantiate()
	HP.personaje_id = id_personaje
	get_tree().change_scene_to_node(HP)

func _al_cancelar(dialogo: ConfirmationDialog) -> void:
	# Si el jugador cancela, quitamos el oscurecido y cerramos el diálogo
	dialogo.queue_free()
		

var datos_busqueda: Dictionary = {
	"unica": false,#booleanos
	"tipo": "cualquiera", "subtipo": "cualquiera", "bonificadores_atributos": "cualquiera", "costo": "cualquiera"} 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_viene_personaje()
	for carta in GestorCarta.listar_cartas():
		cartas_filtradas[carta] = GestorCarta.cargar_carta(carta).a_diccionario()
	cantidad_label.text = str(cartas_filtradas.keys().size())
	mostrar_cartas_filtradas()
	
func _on_atras_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func _on_crear_carta_button_pressed() -> void:
	var CEC := CreacionEdicionCarta.instantiate()
	CEC.carta_actual_id = ""
	get_tree().change_scene_to_node(CEC)

func _on_editar_carta_button_pressed() -> void:
	var CEC := CreacionEdicionCarta.instantiate()
	CEC.carta_actual_id = carta_actual_id
	get_tree().change_scene_to_node(CEC)
	
# Añade esta función a tu compendio_visual.gd (por ejemplo, conéctala a un botón de "Eliminar")
func _on_eliminar_carta_button_pressed() -> void:
	if carta_actual_id == "":
		return
		
	var dialogo := ConfirmationDialog.new()
	dialogo.title = "Eliminar Carta"
	dialogo.dialog_text = "¿Estás seguro de que quieres eliminar esta carta?"
	dialogo.theme = load("res://Assets/tema_claro.tres")
	dialogo.get_ok_button().focus_mode = Control.FOCUS_NONE
	add_child(dialogo)
	
	dialogo.confirmed.connect(func():
		# 1. Borrar de la carpeta del usuario (user://)
		GestorCarta.eliminar_carta(carta_actual_id)
		
		# 2. Borrar del archivo original (res://) - Solo funciona en el editor
		GestorCarta.eliminar_carta_de_json(carta_actual_id)
		
		# 3. Borrar de la memoria (para que desaparezca de la pantalla al instante)
		CompendioCartas.todas_las_cartas.erase(carta_actual_id)
		cartas_filtradas.erase(carta_actual_id)
		
		# 4. Refrescar la UI
		carta_actual_id = ""
		for cv in carta_display.get_children():
			cv.queue_free()
		mostrar_cartas_filtradas()
		
		dialogo.queue_free()
	)
	dialogo.canceled.connect(func(): dialogo.queue_free())
	dialogo.popup_centered(Vector2i(400, 200))
	
func aplicar_filtros() -> void:
	cartas_filtradas = {} # Vaciamos la lista para llenarla de nuevo
	
	for carta_id in CompendioCartas.todas_las_cartas.keys():
		var carta = CompendioCartas.obtener_carta(carta_id)
		var pasa_filtro = true
		
		# Booleanos
		if datos_busqueda["unica"] and not carta.get("unica", false): pasa_filtro = false
			
		# Selectores
		if datos_busqueda["tipo"] != "cualquiera" and carta.get("tipo", "") != datos_busqueda["tipo"]: pasa_filtro = false
		if datos_busqueda["subtipo"] != "cualquiera" and carta.get("subtipo", "") != datos_busqueda["subtipo"]: pasa_filtro = false
		
		if datos_busqueda["bonificadores_atributos"] != "cualquiera":
			var bonos = carta.get("bonificadores_atributos", {})
			if not bonos.has(datos_busqueda["bonificadores_atributos"]): pasa_filtro = false
		
		if datos_busqueda["costo"] != "cualquiera":
			const etiquetas: Dictionary = {
				"fuerza": "puntos_fuerza",
				"destreza": "puntos_destreza",
				"constitucion": "puntos_constitucion",
				"sabiduria": "puntos_sabiduria",
				"inteligencia": "puntos_inteligencia",
				"carisma": "puntos_carisma",
				"dinero": "dinero"
			}
			var costo = carta.get("costo", {})
			if not costo.has(etiquetas[datos_busqueda["costo"]]):
				pasa_filtro = false
			else:
				if not costo[etiquetas[datos_busqueda["costo"]]] > 0:
					pasa_filtro = false
				
		# Búsqueda literal
		if busqueda.text.strip_edges() != "":
			var texto = busqueda.text.to_lower()
			var campo = "titulo" if titulo_check_box.button_pressed else "id"
			if not texto in str(carta.get(campo, "")).to_lower(): pasa_filtro = false
				
		if pasa_filtro:
			cartas_filtradas[carta_id] = carta
	
	cantidad_label.text = str(cartas_filtradas.keys().size())
	mostrar_cartas_filtradas()

# --- MOSTRAR EN PANTALLA ---
func mostrar_cartas_filtradas():
	# 1. Limpiamos el contenedor (esto evita que se dupliquen)
	for hijo in cartas_contenedor.get_children():
		hijo.queue_free()
		
	# 2. Si no hay cartas que coincidan, mostramos un mensaje
	if cartas_filtradas.is_empty():
		var label_vacio := Label.new()
		label_vacio.text = "No se encontraron cartas con estos filtros."
		label_vacio.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cartas_contenedor.add_child(label_vacio)
		return
		
	# 3. Mostramos las cartas filtradas
	for carta in cartas_filtradas.values():
		var cartaUI = carta_button_scene.instantiate()
		cartaUI.id = carta["id"]
		cartaUI.text = carta["titulo"]
		cartaUI.comprada = false
		
		cartaUI.seleccionar.connect(_on_carta_seleccionada)
		cartas_contenedor.add_child(cartaUI)

# --- DISPLAY DE LA CARTA ---
func _on_carta_seleccionada(id_carta: String, _comprada: bool = false):
	if carta_actual_id == id_carta:
		for cv in carta_display.get_children():
			cv.queue_free()
		editar_carta_button.disabled = true
		eliminar_carta_button.disabled = true
		carta_actual_id = ""
		return
	else:
		editar_carta_button.disabled = false
		eliminar_carta_button.disabled = false
		carta_actual_id = id_carta
		
		for cv in carta_display.get_children():
			cv.queue_free()
			
		var datos_carta = CompendioCartas.obtener_carta(id_carta)
		if datos_carta.is_empty(): return
			
		var carta_visual_inst = carta_visual.instantiate()
		carta_display.add_child(carta_visual_inst)
		carta_visual_inst.cargar_visuales(datos_carta)

# --- RESPUESTA A LAS SEÑALES (UI) ---
func _on_id_check_box_toggled(_toggled_on: bool) -> void:
	busqueda.placeholder_text = "buscar por id"
	aplicar_filtros()
	
func _on_titulo_check_box_toggled(_toggled_on: bool) -> void:
	busqueda.placeholder_text = "buscar por titulo"
	aplicar_filtros()

func _on_line_edit_text_changed(_new_text: String) -> void:
	aplicar_filtros()

func _on_tipo_selector_item_selected(index: int) -> void:
	subtipo_selector.clear()
	var subtipos = {
		0: ["cualquiera"],
		1: ["cualquiera", "Pasiva", "Activa"],       # Habilidad
		2: ["cualquiera", "Pack", "Singular"],       # Hechizo
		3: ["cualquiera", "Arma", "Armadura"],       # Equipamiento
		4: ["cualquiera", "Comestible", "Usable"]    # Consumible
	}
	
	# Llenamos el selector de subtipos
	for label in subtipos.get(index, ["cualquiera"]):
		subtipo_selector.add_item(label)
		
	subtipo_selector.select(0) # Seleccionamos "cualquiera" por defecto
		
	datos_busqueda["tipo"] = tipo_selector.get_item_text(index)
	datos_busqueda["subtipo"] = "cualquiera" # Al cambiar de tipo, el subtipo se resetea
	aplicar_filtros()

func _on_subtipo_selector_item_selected(index: int) -> void:
	datos_busqueda["subtipo"] = subtipo_selector.get_item_text(index)
	aplicar_filtros()

func _on_atributo_selector_item_selected(index: int) -> void:
	datos_busqueda["bonificadores_atributos"] = atributo_selector.get_item_text(index)
	aplicar_filtros()

func _on_costo_selector_item_selected(index: int) -> void:
	datos_busqueda["costo"] = costo_selector.get_item_text(index)
	aplicar_filtros()

func _on_unica_cb_toggled(toggled_on: bool) -> void:
	datos_busqueda["unica"] = toggled_on
	aplicar_filtros()
	
