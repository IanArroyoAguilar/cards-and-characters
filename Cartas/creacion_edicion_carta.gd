extends Control

const carta_visual = preload("res://Cartas/carta.tscn")
@onready var carta_display: PanelContainer = $PanelCreacion/Hbox/Control/VBoxContainer/CartaDisplay
var carta_actual_id: String = ""
@onready var resetear_button: Button = $PanelCreacion/Hbox/Control/VBoxContainer/ResetearButton
@onready var datos_guardar: Dictionary = CompendioCartas.obtener_carta(carta_actual_id)

@onready var titulo_input: LineEdit = $PanelCreacion/Hbox/Informacion/HBoxContainer/TituloBox/TituloInput
@onready var unica_cb: CheckBox = $PanelCreacion/Hbox/Informacion/HBoxContainer/UnicaCB
@onready var tipo_selector: OptionButton = $PanelCreacion/Hbox/Informacion/HBoxContainer2/TipoBox/TipoSelector
@onready var subtipo_selector: OptionButton = $PanelCreacion/Hbox/Informacion/HBoxContainer2/SubtipoBox/SubtipoSelector
@onready var descripcion_input: TextEdit = $PanelCreacion/Hbox/Informacion/DescripcionBox/DescripcionInput
# mod atributos
@onready var fuerza_input: LineEdit = $PanelCreacion/Hbox/Informacion/Numericos/BonificadoresAtributos/GridContainer/HBoxContainer/FuerzaInput
@onready var sabiduria_input: LineEdit = $PanelCreacion/Hbox/Informacion/Numericos/BonificadoresAtributos/GridContainer/HBoxContainer2/SabiduriaInput
@onready var destreza_input: LineEdit = $PanelCreacion/Hbox/Informacion/Numericos/BonificadoresAtributos/GridContainer/HBoxContainer3/DestrezaInput
@onready var inteligencia_input: LineEdit = $PanelCreacion/Hbox/Informacion/Numericos/BonificadoresAtributos/GridContainer/HBoxContainer4/InteligenciaInput
@onready var constitucion_input: LineEdit = $PanelCreacion/Hbox/Informacion/Numericos/BonificadoresAtributos/GridContainer/HBoxContainer5/ConstitucionInput
@onready var carisma_input: LineEdit = $PanelCreacion/Hbox/Informacion/Numericos/BonificadoresAtributos/GridContainer/HBoxContainer6/CarismaInput
# costo
@onready var fue_input: LineEdit = $PanelCreacion/Hbox/Informacion/Numericos/Costo/GridContainer/HBoxContainer/FUEInput
@onready var sab_input: LineEdit = $PanelCreacion/Hbox/Informacion/Numericos/Costo/GridContainer/HBoxContainer2/SABInput
@onready var des_input: LineEdit = $PanelCreacion/Hbox/Informacion/Numericos/Costo/GridContainer/HBoxContainer3/DESInput
@onready var int_input: LineEdit = $PanelCreacion/Hbox/Informacion/Numericos/Costo/GridContainer/HBoxContainer4/INTInput
@onready var con_input: LineEdit = $PanelCreacion/Hbox/Informacion/Numericos/Costo/GridContainer/HBoxContainer5/CONInput
@onready var car_input: LineEdit = $PanelCreacion/Hbox/Informacion/Numericos/Costo/GridContainer/HBoxContainer6/CARInput
@onready var dinero_input: LineEdit = $PanelCreacion/Hbox/Informacion/Numericos/Costo/HBoxContainer2/HBoxContainer/DineroInput
@onready var costos_atr := [fue_input, sab_input, des_input, int_input, con_input, car_input] 

func mostrar_carta():
	for cv in carta_display.get_children():
		cv.queue_free()
		
	var carta_visual_inst = carta_visual.instantiate()
	carta_display.add_child(carta_visual_inst)
	carta_visual_inst.cargar_visuales(datos_guardar)
	
func reset_datos():
	# 1. Obtenemos los datos originales de la carta (si estamos editando)
	var datos_carta = CompendioCartas.obtener_carta(carta_actual_id)
	
	# Si es una carta nueva, inicializamos un diccionario vacío
	if datos_carta.is_empty():
		datos_guardar = {
			"costo": {},
			"bonificadores_atributos": {},
			"tipo": "",
			"subtipo": ""
		}
	else:
		# Hacemos una copia profunda para no modificar el original
		datos_guardar = datos_carta.duplicate(true)
	
	const TIPOS := {
		"Habilidad": 0,
		"Hechizo": 1,
		"Equipamiento": 2,
		"Consumible": 3,
	}
	
	var subtipos = {
		0: ["Pasiva", "Activa"],       # Habilidad
		1: ["Pack", "Singular"],       # Hechizo 
		2: ["Arma", "Armadura"],       # Equipamiento
		3: ["Comestible", "Usable"]    # Consumible
	}
	
	# 2. Configurar el Tipo
	var tipo_actual = datos_carta.get("tipo", "")
	if tipo_actual in TIPOS:
		tipo_selector.select(TIPOS[tipo_actual])
		
		# 3. Configurar el Subtipo
		subtipo_selector.clear()
		var lista_subtipos = subtipos.get(tipo_selector.selected, [])
		
		# Llenamos el selector con los subtipos del tipo actual
		for label in lista_subtipos:
			subtipo_selector.add_item(label)
			
		# Buscamos el índice REAL del subtipo actual dentro de la lista
		var subtipo_actual = datos_carta.get("subtipo", "")
		var indice_subtipo = lista_subtipos.find(subtipo_actual)
		
		if indice_subtipo != -1:
			subtipo_selector.select(indice_subtipo)
		else:
			subtipo_selector.select(0) # Si no se encuentra, seleccionamos el primero por defecto
			
	else:
		tipo_selector.select(-1)
		subtipo_selector.clear()
		
	# 4. Llenar los campos de texto
	titulo_input.text = datos_carta.get("titulo", "")
	unica_cb.button_pressed = datos_carta.get("unica", false)
	descripcion_input.text = datos_carta.get("descripcion", "")
	
	# 5. Llenar bonificadores
	var bonos = datos_carta.get("bonificadores_atributos", {})
	fuerza_input.text = str(bonos.get("fuerza", 0))
	sabiduria_input.text = str(bonos.get("sabiduria", 0))
	destreza_input.text = str(bonos.get("destreza", 0))
	inteligencia_input.text = str(bonos.get("inteligencia", 0))
	constitucion_input.text = str(bonos.get("constitucion", 0))
	carisma_input.text = str(bonos.get("carisma", 0))
	
	# 6. Llenar costos
	var costo = datos_carta.get("costo", {})
	fue_input.text = str(costo.get("puntos_fuerza", 0))
	sab_input.text = str(costo.get("puntos_sabiduria", 0))
	des_input.text = str(costo.get("puntos_destreza", 0))
	int_input.text = str(costo.get("puntos_inteligencia", 0))
	con_input.text = str(costo.get("puntos_constitucion", 0))
	car_input.text = str(costo.get("puntos_carisma", 0))
	dinero_input.text = str(costo.get("dinero", 0))
	
	# 7. Refrescar el display visual
	mostrar_carta()
	
func _ready() -> void:
	mostrar_carta()
	if datos_guardar == {}:
		datos_guardar["costo"] = {}
		datos_guardar["bonificadores_atributos"] = {}
	else:
		reset_datos()

func _on_atras_button_pressed() -> void:
	var dialogo := ConfirmationDialog.new()
	dialogo.title = ""
	dialogo.dialog_text = "¿Estás seguro de que quieres regresar?\nSe perderán todos los cambios."
	dialogo.theme = load("res://Assets/tema_claro.tres")
	
	# Quitar el foco del botón OK para evitar el recuadro blanco
	dialogo.get_ok_button().focus_mode = Control.FOCUS_NONE
	dialogo.get_cancel_button().focus_mode = Control.FOCUS_NONE
	
	add_child(dialogo)
	
	# 2. Conectamos las señales usando .bind() para pasarle el diálogo
	dialogo.confirmed.connect(_al_confirmar_atras.bind(dialogo))
	dialogo.canceled.connect(_al_cancelar.bind(dialogo))
	
	dialogo.popup_centered(Vector2i(400, 200))

func _al_confirmar_atras(_dialogo: ConfirmationDialog) -> void:
	get_tree().change_scene_to_file("res://Cartas/compendio_visual.tscn")

func _al_cancelar(dialogo: ConfirmationDialog) -> void:
	# Si el jugador cancela, quitamos el oscurecido y cerramos el diálogo
	dialogo.queue_free()

func _on_resetear_button_pressed() -> void:
	var dialogo := ConfirmationDialog.new()
	dialogo.title = ""
	dialogo.dialog_text = "¿Estás seguro de que quieres resetear?\nSe perderán todos los cambios."
	dialogo.theme = load("res://Assets/tema_claro.tres")
	
	# Quitar el foco del botón OK para evitar el recuadro blanco
	dialogo.get_ok_button().focus_mode = Control.FOCUS_NONE
	dialogo.get_cancel_button().focus_mode = Control.FOCUS_NONE
	
	add_child(dialogo)
	
	# 2. Conectamos las señales usando .bind() para pasarle el diálogo
	dialogo.confirmed.connect(reset_datos)
	dialogo.canceled.connect(_al_cancelar.bind(dialogo))
	
	dialogo.popup_centered(Vector2i(400, 200))

func _on_listo_button_pressed() -> void:
	if titulo_input.text == "":
		_mostrar_error("El titulo no puede estar vacio")
		return
		
	if descripcion_input.text == "":
		_mostrar_error("La descripción no puede estar vacia")
		return
		
	if not tipo_selector.selected in [0,1,2,3]:
		_mostrar_error("Debe escoger un tipo")
		return
		
	if not subtipo_selector.selected in [0,1]:
		_mostrar_error("Debe escoger un subtipo")
		return
		
	var dialogo := ConfirmationDialog.new()
	dialogo.title = ""
	dialogo.dialog_text = "¿Estás seguro de que terminar?\nSe guardará la carta."
	dialogo.theme = load("res://Assets/tema_claro.tres")
	
	# Quitar el foco del botón OK para evitar el recuadro blanco
	dialogo.get_ok_button().focus_mode = Control.FOCUS_NONE
	dialogo.get_cancel_button().focus_mode = Control.FOCUS_NONE
	
	add_child(dialogo)
	
	# 2. Conectamos las señales usando .bind() para pasarle el diálogo
	dialogo.confirmed.connect(_al_confirmar_listo)
	dialogo.canceled.connect(_al_cancelar.bind(dialogo))
	
	dialogo.popup_centered(Vector2i(400, 200))
	
func _al_confirmar_listo():
	# Si es una carta nueva, generamos el ID
	if carta_actual_id == "":
		carta_actual_id = GestorCarta.generar_id(datos_guardar.get("titulo"))
	
	# Asignamos el ID correcto a los datos
	datos_guardar["id"] = carta_actual_id

	var carta = Carta.new()
	carta.desde_diccionario(datos_guardar)
	
	# Guardamos (sobrescribe si ya existía)
	GestorCarta.guardar_carta(carta, carta_actual_id)
	
	# Volvemos al compendio
	get_tree().change_scene_to_file("res://Cartas/compendio_visual.tscn")
	
func _mostrar_error(mensaje: String) -> void:
	var dialogo = AcceptDialog.new()
	dialogo.dialog_text = mensaje
	dialogo.title = "Error de Validación"
	
	# 1. Añadimos el diálogo al árbol primero para que exista el botón
	add_child(dialogo)
	
	# 2. Obtenemos el botón OK y le quitamos el foco
	var btn_ok = dialogo.get_ok_button()
	if btn_ok:
		btn_ok.focus_mode = Control.FOCUS_NONE
		
	# 3. Mostramos el diálogo y conectamos el cierre
	dialogo.popup_centered()
	dialogo.confirmed.connect(func(): dialogo.queue_free())

func _negar_escritura(line_edit: LineEdit):
	var posicion_cursor = line_edit.caret_column
	line_edit.text = line_edit.text.substr(0, posicion_cursor - 1) + line_edit.text.substr(posicion_cursor)
	line_edit.caret_column = posicion_cursor - 1
	return
		
func _filtrar_solo_numeros(line_edit: LineEdit, new_text: String) -> void:
	# Si el texto está vacío, lo dejamos así (para permitir borrar)
	if new_text == "":
		return
		
	# Comprobamos si el texto es un número válido
	if not new_text.is_valid_int():
		_negar_escritura(line_edit)

func _on_dinero_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(dinero_input ,new_text)
	var line_edit = dinero_input
	for atrib in costos_atr:
		if int(atrib.text) > 0:
			_negar_escritura(line_edit)
			_mostrar_error("La carta no puede costar dinero y puntos de atributos1")
			return
	
	datos_guardar["costo"]["dinero"] = int(dinero_input.text)
	mostrar_carta()
	
func dinero_es_0() -> bool:
	return int(dinero_input.text) == 0 or dinero_input.text == ""

func _on_fue_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(fue_input ,new_text)
	var line_edit = fue_input
	
	if not dinero_es_0():
		_negar_escritura(line_edit)
		_mostrar_error("La carta no puede costar dinero y puntos de atributos2")
		return
		
	var counter:= 0
	 
	for atrib in costos_atr:
		if int(atrib.text) > 0:
			counter += 1
			if counter > 2:
				_negar_escritura(line_edit)
				_mostrar_error("Se pueden modificar a lo sumo dos costos de puntos de atributo")
				return
	
	datos_guardar["costo"]["puntos_fuerza"] = int(fue_input.text)
	mostrar_carta()

func _on_sab_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(sab_input ,new_text)
	var line_edit = sab_input
	
	if not dinero_es_0():
		_negar_escritura(line_edit)
		_mostrar_error("La carta no puede costar dinero y puntos de atributos3")
		return
		
	var counter:= 0
	 
	for atrib in costos_atr:
		if int(atrib.text) > 0:
			counter += 1
			if counter > 2:
				_negar_escritura(line_edit)
				_mostrar_error("Se pueden modificar a lo sumo dos costos de puntos de atributo")
				return
				
	datos_guardar["costo"]["puntos_sabiduria"] = int(sab_input.text)
	mostrar_carta()
	
func _on_des_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(des_input ,new_text)
	var line_edit = des_input
	
	if not dinero_es_0():
		_negar_escritura(line_edit)
		_mostrar_error("La carta no puede costar dinero y puntos de atributos4")
		return
	var counter:= 0
	 
	for atrib in costos_atr:
		if int(atrib.text) > 0:
			counter += 1
			if counter > 2:
				_negar_escritura(line_edit)
				_mostrar_error("Se pueden modificar a lo sumo dos costos de puntos de atributo")
				return
	datos_guardar["costo"]["puntos_destreza"] = int(des_input.text)
	mostrar_carta()
	
func _on_int_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(int_input ,new_text)
	var line_edit = int_input
	
	if not dinero_es_0():
		_negar_escritura(line_edit)
		_mostrar_error("La carta no puede costar dinero y puntos de atributos5")
		return
	var counter:= 0
	 
	for atrib in costos_atr:
		if int(atrib.text) > 0:
			counter += 1
			if counter > 2:
				_negar_escritura(line_edit)
				_mostrar_error("Se pueden modificar a lo sumo dos costos de puntos de atributo")
				return
	datos_guardar["costo"]["puntos_inteligencia"] = int(int_input.text)
	mostrar_carta()
	
func _on_con_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(con_input ,new_text)
	var line_edit = con_input
	
	if not dinero_es_0():
		_negar_escritura(line_edit)
		_mostrar_error("La carta no puede costar dinero y puntos de atributos6")
		return
		
	var counter:= 0
	
	for atrib in costos_atr:
		if int(atrib.text) > 0:
			counter += 1
			if counter > 2:
				_negar_escritura(line_edit)
				_mostrar_error("Se pueden modificar a lo sumo dos costos de puntos de atributo")
				return
	datos_guardar["costo"]["puntos_constitucion"] = int(con_input.text)
	mostrar_carta()
	
func _on_car_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(car_input ,new_text)
	var line_edit = car_input
	
	if not dinero_es_0():
		_negar_escritura(line_edit)
		_mostrar_error("La carta no puede costar dinero y puntos de atributos7")
		return
	var counter:= 0
	for atrib in costos_atr:
		if int(atrib.text) > 0:
			counter += 1
			if counter > 2:
				_negar_escritura(line_edit)
				_mostrar_error("Se pueden modificar a lo sumo dos costos de puntos de atributo")
				return
	datos_guardar["costo"]["puntos_carisma"] = int(car_input.text)
	mostrar_carta()
	
func _on_carisma_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(carisma_input ,new_text)
	datos_guardar["bonificadores_atributos"]["carisma"] = int(carisma_input.text)
	
func _on_constitucion_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(constitucion_input ,new_text)
	datos_guardar["bonificadores_atributos"]["constitucion"] = int(constitucion_input.text)

func _on_inteligencia_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(inteligencia_input ,new_text)
	datos_guardar["bonificadores_atributos"]["inteligencia"] = int(inteligencia_input.text)

func _on_destreza_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(destreza_input ,new_text)
	datos_guardar["bonificadores_atributos"]["destreza"] = int(destreza_input.text)

func _on_sabiduria_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(sabiduria_input ,new_text)
	datos_guardar["bonificadores_atributos"]["sabiduria"] = int(sabiduria_input.text)

func _on_fuerza_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(fuerza_input ,new_text)
	datos_guardar["bonificadores_atributos"]["fuerza"] = int(fuerza_input.text)

func _on_tipo_selector_item_selected(index: int) -> void:
	subtipo_selector.clear()
	var subtipos = {
		0: ["Pasiva", "Activa"],       # Habilidad
		1: ["Pack", "Singular"],       # Hechizo
		2: ["Arma", "Armadura"],       # Equipamiento
		3: ["Comestible", "Usable"]    # Consumible
	}
	# Llenamos el selector de subtipos
	for label in subtipos.get(index):
		subtipo_selector.add_item(label)
		
	subtipo_selector.select(0) # Seleccionamos "cualquiera" por defecto
		
	datos_guardar["tipo"] = tipo_selector.get_item_text(index)
	datos_guardar["subtipo"] = subtipo_selector.get_item_text(0)
	mostrar_carta()

func _on_subtipo_selector_item_selected(index: int) -> void:
	datos_guardar["subtipo"] = subtipo_selector.get_item_text(index)
	mostrar_carta()

func _on_titulo_input_text_changed(_new_text: String) -> void:
	datos_guardar["titulo"] = titulo_input.text
	mostrar_carta()

func _on_descripcion_input_text_changed() -> void:
	datos_guardar["descripcion"] = descripcion_input.text
	mostrar_carta()

func _on_unica_cb_toggled(toggled_on: bool) -> void:
	datos_guardar["unica"] = toggled_on
