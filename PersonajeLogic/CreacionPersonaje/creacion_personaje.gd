extends Control
#Variables de Informacion General
@onready var nombre_input: LineEdit = $DivisorPrincipal/PanelInformacion/Subpaneles/InformacionGeneral/FormsImagenNivel/FormNombre/NombreInput
@onready var raza_selector: OptionButton = $DivisorPrincipal/PanelInformacion/Subpaneles/InformacionGeneral/FormsNombreRaza/FormRaza/RazaSelector
@onready var nivel_input: LineEdit = $DivisorPrincipal/PanelInformacion/Subpaneles/InformacionGeneral/FormsNombreRaza/FormNivel/NivelInput
#Variables de Atributos
@onready var p_disponible_cantidad: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/Header/PDisponibleCantidad
@onready var fuerza_input: LineEdit = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/FDC/FormFuerza/FuerzaInput
@onready var destreza_input: LineEdit = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/FDC/FormDestreza/DestrezaInput
@onready var constitucion_input: LineEdit = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/FDC/FormConstitucion/ConstitucionInput
@onready var sabiduria_input: LineEdit = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/SIA/FormSabiduria/SabiduriaInput
@onready var inteligencia_input: LineEdit = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/SIA/FormInteligencia/InteligenciaInput
@onready var carisma_input: LineEdit = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/SIA/FormCarisma/CarismaInput
@onready var atributos_label: Array[LineEdit] = [
	fuerza_input,
	sabiduria_input,
	destreza_input,
	inteligencia_input,
	constitucion_input,
	carisma_input,
]
@onready var FUE: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/FDC/FormFuerza/FUE
@onready var DES: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/FDC/FormDestreza/DES
@onready var CON: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/FDC/FormConstitucion/CON
@onready var SAB: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/SIA/FormSabiduria/SAB
@onready var INT: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/SIA/FormInteligencia/INT
@onready var CAR: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/SIA/FormCarisma/CAR
#Botones
@onready var back_button1: Button = $DivisorPrincipal/PanelInformacion/Subpaneles/Botones/BackButton1
@onready var listo_button1: Button = $DivisorPrincipal/PanelInformacion/Subpaneles/Botones/ListoButton1
@onready var boton_comprar: Button = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer2/BotonComprar
@onready var back_button_2: Button = $DivisorPrincipal/PanelCartas/VSplitContainer/Botones/BackButton2
@onready var listo_button_2: Button = $DivisorPrincipal/PanelCartas/VSplitContainer/Botones/ListoButton2

#Gastables
@onready var pd_fue: Label = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer/PuntosDisponibles/HSplitContainer/PD_FDC/FormFuerza/PD_FUE
@onready var pd_des: Label = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer/PuntosDisponibles/HSplitContainer/PD_FDC/FormDestreza/PD_DES
@onready var pd_con: Label = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer/PuntosDisponibles/HSplitContainer/PD_FDC/FormConstitucion/PD_CON
@onready var pd_int: Label = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer/PuntosDisponibles/HSplitContainer/PD_SIA/FormInteligencia/PD_INT
@onready var pd_car: Label = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer/PuntosDisponibles/HSplitContainer/PD_SIA/FormCarisma/PD_CAR
@onready var pd_sab: Label = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer/PuntosDisponibles/HSplitContainer/PD_SIA/FormSabiduria/PD_SAB
@onready var dinero_label: Label = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer/PuntosDisponibles/Header2/DineroLabel
#Utiles
@onready var carta_display: PanelContainer = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer2/CartaDisplay
var carta_button_scene = preload("res://Cartas/CartaButtonEntrada.tscn")
const CARTA = preload("res://Cartas/carta.tscn")
var carta_actual_id: String = "" # Guarda la ID de la carta que se está viendo
var cartas_compradas_ids: Array[String] = [] # Lista temporal de lo que se lleva comprado
@onready var cartas_compradas: GridContainer = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer/ScrollContainer/CartasCompradas
@onready var cartas_contenedor: GridContainer = $DivisorPrincipal/PanelCartas/VSplitContainer/ScrollContainer/CartasContenedor

func _ready() -> void:
	#for input in atributos_label:
	#	input.focus_entered.connect(func(): input.select_all())
	boton_comprar.disabled = true
	#p_disponible_cantidad.text = "65"

# Esta función la puedes usar para todos los inputs
func _filtrar_solo_numeros(line_edit: LineEdit, new_text: String) -> void:
	# Si el texto está vacío, lo dejamos así (para permitir borrar)
	if new_text == "":
		return
		
	# Comprobamos si el texto es un número válido
	if not new_text.is_valid_int():
		# Si no es un número, revertimos al texto anterior
		var posicion_cursor = line_edit.caret_column
		line_edit.text = line_edit.text.substr(0, posicion_cursor - 1) + line_edit.text.substr(posicion_cursor)
		line_edit.caret_column = posicion_cursor - 1
		return
	var sum:= 0
	
	if not line_edit == nivel_input:
		# Opcional: Evitar que escriban números mayores a 15 (o el máximo que quieras)
		if int(new_text) > 17+int(nivel_input.text):
			line_edit.text = str(17+int(nivel_input.text)) # Forzar el máximo
			line_edit.caret_column = line_edit.text.length()
		
		FUE.text = {0: "+", -1: "", 1: "+"}[sign(floori((int(fuerza_input.text) - 10) / 2.0))] + str(floori((int(fuerza_input.text) - 10) / 2.0))
		DES.text = {0: "+", -1: "", 1: "+"}[sign(floori((int(fuerza_input.text) - 10) / 2.0))] + str(floori((int(destreza_input.text) - 10) / 2.0))
		CON.text = {0: "+", -1: "", 1: "+"}[sign(floori((int(fuerza_input.text) - 10) / 2.0))] + str(floori((int(constitucion_input.text) - 10) / 2.0))
		SAB.text = {0: "+", -1: "", 1: "+"}[sign(floori((int(fuerza_input.text) - 10) / 2.0))] + str(floori((int(sabiduria_input.text) - 10) / 2.0))
		INT.text = {0: "+", -1: "", 1: "+"}[sign(floori((int(fuerza_input.text) - 10) / 2.0))] + str(floori((int(inteligencia_input.text) - 10) / 2.0))
		CAR.text = {0: "+", -1: "", 1: "+"}[sign(floori((int(fuerza_input.text) - 10) / 2.0))] + str(floori((int(carisma_input.text) - 10) / 2.0))
		for at in atributos_label:
			sum += int(at.text)
	else:
		for at in atributos_label:
			sum += int(at.text)
			
	p_disponible_cantidad.text = str(67+int(nivel_input.text)-sum)
		
func _on_fuerza_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(fuerza_input, new_text)

func _on_destreza_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(destreza_input, new_text)

func _on_constitucion_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(constitucion_input, new_text)
	
func _on_sabiduria_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(sabiduria_input, new_text)
	
func _on_inteligencia_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(inteligencia_input, new_text)
	
func _on_carisma_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(carisma_input, new_text)

func _on_nivel_input_text_changed(new_text: String) -> void:
	_filtrar_solo_numeros(nivel_input, new_text)
	
func actualizar_puntos_compra() -> void:
	# Los puntos disponibles se basan en el modificador de cada atributo final
	pd_fue.text = str(max(0,(int(nivel_input.text)+1)*floori((int(fuerza_input.text) - 10) / 2.0)))
	pd_des.text = str(max(0,(int(nivel_input.text)+1)*floori((int(destreza_input.text) - 10) / 2.0)))
	pd_con.text = str(max(0,(int(nivel_input.text)+1)*floori((int(constitucion_input.text) - 10) / 2.0)))
	pd_sab.text = str(max(0,(int(nivel_input.text)+1)*floori((int(sabiduria_input.text) - 10) / 2.0)))
	pd_int.text = str(max(0,(int(nivel_input.text)+1)*floori((int(inteligencia_input.text) - 10) / 2.0)))
	pd_car.text = str(max(0,(int(nivel_input.text)+1)*floori((int(carisma_input.text) - 10) / 2.0)))
	
	# Asignamos el dinero inicial
	dinero_label.text = "100" # O la regla que uses
	
func _on_listo_button_1_pressed() -> void:
	# 0. Verificar Nivel
	if nivel_input.text.strip_edges().is_empty() or not nivel_input.text.is_valid_int() or int(nivel_input.text) <= 0:
		_mostrar_error("Debes introducir un nivel válido (mayor que 0).")
		return
	# 1. Verificar Nombre
	if nombre_input.text.strip_edges().is_empty():
		_mostrar_error("Debes escribir un nombre.")
		return
		
	# 2. Verificar que se escogió una raza
	if raza_selector.selected == -1:
		_mostrar_error("Debes escoger una raza.")
		return

	# 3. Recoger los atributos base (sin contar la raza)
	var atributos = {
		"fuerza": int(fuerza_input.text),
		"destreza": int(destreza_input.text),
		"constitucion": int(constitucion_input.text),
		"inteligencia": int(inteligencia_input.text),
		"sabiduria": int(sabiduria_input.text),
		"carisma": int(carisma_input.text)
	}
	
	var suma_total = 0
	for valor in atributos.values():
		suma_total += valor
		
		# Verificar mínimos y máximos base
		if valor < 7:
			_mostrar_error("Cada atributo debe estar entre 7 y 15+nivel antes de aplicar la raza.")
			return

	# Verificar que la suma sea 68
	if suma_total != 67+int(nivel_input.text):
		_mostrar_error("La suma de los atributos debe ser exactamente 67+nivel. Actual: " + str(suma_total))
		return
		
	# 4. Aplicar los bonos de la raza (Lógica personalizada)
	# Como tienes las razas en un OptionButton, aquí definimos los bonos:
	var bonos_raza = {
		0: ["destreza", "inteligencia", "sabiduria"], # Elfo (DEX, INT, SAB)
		1: ["fuerza", "constitucion", "sabiduria"],   # Orco (FUE, CON, SAB)
		2: ["destreza", "inteligencia", "carisma"], # Humano
		3: ["fuerza", "constitucion", "inteligencia"]    # Enano
	}
	
	var raza_seleccionada = raza_selector.selected
	
	# Comprobamos que al sumar el bono no pase de 17
	for atributo in atributos.keys():
		if atributos[atributo] > 15+int(nivel_input.text) and not atributo in bonos_raza[raza_seleccionada]:
			_mostrar_error("El atributo " + atributo + " supera el máximo de 15\n y no esta entre las bonificaciones de raza.")
			return

	# 5. Si todo está OK, actualizamos los labels con los valores finales (Base + Raza)
	# (Opcional, pero recomendado para que el jugador vea cómo quedó su personaje)

	# 6. Desbloquear la Fase 2 (Cartas)
	$DivisorPrincipal/PanelInformacion.modulate = Color(0.5, 0.5, 0.5, 1)
	$DivisorPrincipal/PanelCartas.modulate = Color(1.0, 1.0, 1.0, 1.0)
	listo_button1.disabled = true # Deshabilitar este botón para que no se vuelva a pulsar
	nombre_input.editable = false
	raza_selector.disabled = true
	# Bloquear también los inputs de atributos
	for al in atributos_label:
		al.editable = false
		
	# Ahora sí, cargamos las cartas disponibles (usando los puntos restantes)
	# Al inicio de la Fase 2, no ha comprado nada, así que tiene sus puntos de modificador
	actualizar_puntos_compra()
	desplegar_cartas_disponibles()

func _on_back_button_1_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	
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

func restar_puntos(costo: Dictionary) -> bool:
	# Mapeo de llaves del JSON a los Labels de la interfaz
	var labels = {
		"puntos_fuerza": pd_fue,
		"puntos_destreza": pd_des,
		"puntos_constitucion": pd_con,
		"puntos_sabiduria": pd_sab,
		"puntos_inteligencia": pd_int,
		"puntos_carisma": pd_car,
		"dinero": dinero_label
	}
	
	for llave in costo.keys():
		if costo[llave] > 0 and llave in labels:
			if int(labels[llave].text) < costo[llave]:
				return false # No hay saldo suficiente
				
	# 2. Si hay saldo, restar
	for llave in costo.keys():
		if costo[llave] > 0 and llave in labels:
			var valor_actual = int(labels[llave].text)
			labels[llave].text = str(valor_actual - costo[llave])
			
	return true

func _on_boton_comprar_pressed():
	if carta_actual_id == "":
		return
		
	var datos_carta = CompendioCartas.obtener_carta(carta_actual_id)
	if datos_carta.is_empty():
		return
	
	# Verificamos si la carta es única
	var es_unica = datos_carta.get("unica", false)
	
	# LÓGICA DE REVERTIR: 
	# Solo revertimos si la carta está comprada Y (es única O el botón dice "Revertir")
	# Como ya controlamos el texto del botón en _on_carta_seleccionada, usamos eso:
	if boton_comprar.text == "Revertir":
		cartas_compradas_ids.erase(carta_actual_id) # Quitamos una instancia
		
		# Sumar los puntos de vuelta
		var costo = datos_carta["costo"]
		pd_fue.text = str(int(pd_fue.text) + costo.get("puntos_fuerza", 0))
		pd_des.text = str(int(pd_des.text) + costo.get("puntos_destreza", 0))
		pd_con.text = str(int(pd_con.text) + costo.get("puntos_constitucion", 0))
		pd_sab.text = str(int(pd_sab.text) + costo.get("puntos_sabiduria", 0))
		pd_int.text = str(int(pd_int.text) + costo.get("puntos_inteligencia", 0))
		pd_car.text = str(int(pd_car.text) + costo.get("puntos_carisma", 0))
		dinero_label.text = str(int(dinero_label.text) + costo.get("dinero", 0))
		
		desplegar_cartas_disponibles()
		desplegar_cartas_compradas()
		
		# Limpiamos el display
		for cv in carta_display.get_children():
			cv.queue_free()
		carta_actual_id = ""
		boton_comprar.disabled = true
		boton_comprar.text = "Comprar"
		
	# LÓGICA DE COMPRAR:
	else:
		# Si es única y ya la tiene, no dejamos comprar otra
		if es_unica and cartas_compradas_ids.has(carta_actual_id):
			_mostrar_error("Ya tienes esta carta única.")
			return
			
		if restar_puntos(datos_carta["costo"]):
			cartas_compradas_ids.append(carta_actual_id)
			
			desplegar_cartas_disponibles()
			desplegar_cartas_compradas()
			
			# Si compraste una carta no única, el botón sigue diciendo "Comprar"
			# y la carta sigue en el display, lista para comprar otra igual.
			if es_unica:
				for cv in carta_display.get_children():
					cv.queue_free()
				carta_actual_id = ""
				boton_comprar.disabled = true
		else:
			_mostrar_error("No tienes suficientes puntos/dinero para: " + datos_carta["titulo"])
					
func desplegar_cartas_disponibles():
	var puntos_compra: Dictionary = {
		"puntos_fuerza": int(pd_fue.text),
		"puntos_destreza": int(pd_des.text),
		"puntos_constitucion": int(pd_con.text),
		"puntos_sabiduria": int(pd_sab.text),
		"puntos_inteligencia": int(pd_int.text),
		"puntos_carisma": int(pd_car.text),
		"dinero": int(dinero_label.text)
	}
	
	# Limpiamos el contenedor
	for hijo in cartas_contenedor.get_children():
		hijo.queue_free()
	
	var cartas = CompendioCartas.get_cartas_disponibles(puntos_compra)
	
	for carta in cartas:
		var cartaUI = carta_button_scene.instantiate()
		cartaUI.id = carta["id"]
		cartaUI.text = carta["titulo"]
		cartaUI.comprada = false # <-- AÑADIR ESTO
		
		# Conectamos las nuevas señales
		cartaUI.seleccionar.connect(_on_carta_seleccionada)
		cartaUI.comprar.connect(_on_carta_comprada)
		
		cartas_contenedor.add_child(cartaUI)

func desplegar_cartas_compradas():
	for hijo in cartas_compradas.get_children():
		hijo.queue_free()
	for carta in cartas_compradas_ids:
		var cartaUI = carta_button_scene.instantiate()
		cartaUI.id = carta
		cartaUI.text = CompendioCartas.obtener_carta(carta)["titulo"]
		cartaUI.comprada = true 
		# Conectamos las nuevas señales
		cartaUI.seleccionar.connect(_on_carta_seleccionada)
		cartaUI.comprar.connect(_on_carta_comprada)
		
		cartas_compradas.add_child(cartaUI)

func _on_carta_seleccionada(id_carta: String, comprada: bool = false):
	for cv in carta_display.get_children():
		cv.queue_free()
	
	carta_actual_id = id_carta
	var datos_carta = CompendioCartas.obtener_carta(id_carta)
	if datos_carta.is_empty(): return
		
	var carta_visual = CARTA.instantiate()
	carta_display.add_child(carta_visual)
	carta_visual.cargar_visuales(datos_carta)
	
	boton_comprar.disabled = false
	
	# Si el botón que tocamos está en la lista de compradas (comprada == true),
	# entonces el botón de acción debe decir "Revertir".
	if comprada:
		boton_comprar.text = "Revertir"
	else:
		boton_comprar.text = "Comprar"
		
func _on_carta_comprada(id_carta: String):
	if carta_actual_id == "":
		return
		
	var datos_carta = CompendioCartas.obtener_carta(carta_actual_id)
	if datos_carta.is_empty():
		return
	
	# Verificamos si la carta es única
	var es_unica = datos_carta.get("unica", false)
	
	# LÓGICA DE REVERTIR: 
	# Solo revertimos si la carta está comprada Y (es única O el botón dice "Revertir")
	# Como ya controlamos el texto del botón en _on_carta_seleccionada, usamos eso:
	if boton_comprar.text == "Revertir":
		cartas_compradas_ids.erase(carta_actual_id) # Quitamos una instancia
		
		# Sumar los puntos de vuelta
		var costo = datos_carta["costo"]
		pd_fue.text = str(int(pd_fue.text) + costo.get("puntos_fuerza", 0))
		pd_des.text = str(int(pd_des.text) + costo.get("puntos_destreza", 0))
		pd_con.text = str(int(pd_con.text) + costo.get("puntos_constitucion", 0))
		pd_sab.text = str(int(pd_sab.text) + costo.get("puntos_sabiduria", 0))
		pd_int.text = str(int(pd_int.text) + costo.get("puntos_inteligencia", 0))
		pd_car.text = str(int(pd_car.text) + costo.get("puntos_carisma", 0))
		dinero_label.text = str(int(dinero_label.text) + costo.get("dinero", 0))
		
		desplegar_cartas_disponibles()
		desplegar_cartas_compradas()
		
		# Limpiamos el display
		for cv in carta_display.get_children():
			cv.queue_free()
		carta_actual_id = ""
		boton_comprar.disabled = true
		boton_comprar.text = "Comprar"
		
	# LÓGICA DE COMPRAR:
	else:
		# Si es única y ya la tiene, no dejamos comprar otra
		if es_unica and cartas_compradas_ids.has(carta_actual_id):
			_mostrar_error("Ya tienes esta carta única.")
			return
			
		if restar_puntos(datos_carta["costo"]):
			cartas_compradas_ids.append(carta_actual_id)
			
			desplegar_cartas_disponibles()
			desplegar_cartas_compradas()
			
			# Si compraste una carta no única, el botón sigue diciendo "Comprar"
			# y la carta sigue en el display, lista para comprar otra igual.
			if es_unica:
				for cv in carta_display.get_children():
					cv.queue_free()
				carta_actual_id = ""
				boton_comprar.disabled = true
		else:
			_mostrar_error("No tienes suficientes puntos/dinero para: " + datos_carta["titulo"])

	
func _on_back_button_2_pressed() -> void:
	# 1. Devolver los puntos de todas las cartas compradas antes de vaciar la lista
	for id_carta in cartas_compradas_ids:
		var datos_carta = CompendioCartas.obtener_carta(id_carta)
		if not datos_carta.is_empty():
			var costo = datos_carta["costo"]
			# Sumamos los puntos de vuelta (igual que en la función de revertir)
			pd_fue.text = str(int(pd_fue.text) + costo.get("puntos_fuerza", 0))
			pd_des.text = str(int(pd_des.text) + costo.get("puntos_destreza", 0))
			pd_con.text = str(int(pd_con.text) + costo.get("puntos_constitucion", 0))
			pd_sab.text = str(int(pd_sab.text) + costo.get("puntos_sabiduria", 0))
			pd_int.text = str(int(pd_int.text) + costo.get("puntos_inteligencia", 0))
			pd_car.text = str(int(pd_car.text) + costo.get("puntos_carisma", 0))
			dinero_label.text = str(int(dinero_label.text) + costo.get("dinero", 0))
			
	# 2. Vaciar la lista de compras
	cartas_compradas_ids.clear()
	
	# 3. Limpiar las interfaces visuales
	for hijo in cartas_contenedor.get_children():
		hijo.queue_free()
	for hijo in cartas_compradas.get_children():
		hijo.queue_free()
	for cv in carta_display.get_children():
		cv.queue_free()
		
	carta_actual_id = ""
	boton_comprar.disabled = true
	boton_comprar.text = "Comprar"
	
	# 4. Volver a bloquear la Fase 2 y desbloquear la Fase 1
	$DivisorPrincipal/PanelInformacion.modulate = Color(1.0, 1.0, 1.0, 1.0) # Quitar el oscurecido
	$DivisorPrincipal/PanelCartas.modulate = Color(0.5, 0.5, 0.5, 1) # Oscurecer cartas (o volver a poner tu Overlay)
	
	listo_button1.disabled = false
	nombre_input.editable = true
	raza_selector.disabled = false
	nivel_input.editable = true
	for al in atributos_label:
		al.editable = true
		
	print("Fase 2 cancelada. Puntos devueltos y listo para editar de nuevo.")

func _on_listo_button_2_pressed() -> void:
	# 1. Creamos el diálogo de confirmación
	var dialogo := ConfirmationDialog.new()
	dialogo.title = "Confirmar Personaje"
	dialogo.dialog_text = "¿Estás seguro de que quieres crear el personaje con estas cartas?\nSe guardarán todos los cambios."
	dialogo.theme = load("res://Assets/tema_claro.tres")
	
	# Quitar el foco del botón OK para evitar el recuadro blanco
	dialogo.get_ok_button().focus_mode = Control.FOCUS_NONE
	dialogo.get_cancel_button().focus_mode = Control.FOCUS_NONE
	
	add_child(dialogo)
	
	# 2. Conectamos las señales usando .bind() para pasarle el diálogo
	dialogo.confirmed.connect(_al_confirmar_creacion.bind(dialogo))
	dialogo.canceled.connect(_al_cancelar_creacion.bind(dialogo))
	
	dialogo.popup_centered(Vector2i(400, 200))

func _al_confirmar_creacion(dialogo: ConfirmationDialog) -> void:
	# 1. Crear el recurso Personaje
	var nuevo_personaje = Personaje.new()
	
	# 2. Recoger la información general
	nuevo_personaje.nombre = nombre_input.text.strip_edges()
	nuevo_personaje.raza = raza_selector.get_item_text(raza_selector.selected).split(" ")[0]
	nuevo_personaje.nivel = int(nivel_input.text)
	
	# 3. Recoger los atributos finales (Base + Raza, que ya están en los LineEdit)
	nuevo_personaje.fuerza = int(fuerza_input.text)
	nuevo_personaje.destreza = int(destreza_input.text)
	nuevo_personaje.constitucion = int(constitucion_input.text)
	nuevo_personaje.inteligencia = int(inteligencia_input.text)
	nuevo_personaje.sabiduria = int(sabiduria_input.text)
	nuevo_personaje.carisma = int(carisma_input.text)
	
	# 4. Asignar los puntos RESTANTES (los que no se gastaron en cartas)
	nuevo_personaje.puntos_fuerza = int(pd_fue.text)
	nuevo_personaje.puntos_destreza = int(pd_des.text)
	nuevo_personaje.puntos_constitucion = int(pd_con.text)
	nuevo_personaje.puntos_sabiduria = int(pd_sab.text)
	nuevo_personaje.puntos_inteligencia = int(pd_int.text)
	nuevo_personaje.puntos_carisma = int(pd_car.text)
	nuevo_personaje.dinero = int(dinero_label.text)
	
	# 5. Asignar las cartas compradas
	nuevo_personaje.cartas_equipadas = cartas_compradas_ids
	
	# 5.5 Reflejar cambios de las cartas en los atributos
	for atributo in ["fuerza", "destreza", "constitucion", "sabiduria", "inteligencia", "carisma"]:
		for id_carta in nuevo_personaje.cartas_equipadas:
			var carta = CompendioCartas.obtener_carta(id_carta)
			if carta.has("bonificadores_atributos") and carta["bonificadores_atributos"].has(atributo):
				nuevo_personaje.set(atributo,nuevo_personaje.get(atributo) + carta["bonificadores_atributos"][atributo])
	
	# 6 Crear Stats
	nuevo_personaje.max_vida = nuevo_personaje.constitucion
	nuevo_personaje.vida = nuevo_personaje.constitucion
	nuevo_personaje.max_hechizos = 2*nuevo_personaje.modificador("inteligencia")
	nuevo_personaje.hechizos = nuevo_personaje.max_hechizos
	nuevo_personaje.CA = 10 + nuevo_personaje.modificador("destreza")
	
	# 7. Generar ID y Guardar
	var id_nuevo = GestorPersonaje.generar_id(nuevo_personaje.nombre)
	var error = GestorPersonaje.guardar_personaje(nuevo_personaje, id_nuevo)
	
	dialogo.queue_free()
	
	if error == OK:
		print("¡Personaje guardado con éxito!")
		# Volver a la escena principal
		get_tree().change_scene_to_file("res://main.tscn")
	else:
		_mostrar_error("Hubo un error al guardar el personaje.")
		# Si falla, quitamos el oscurecido para que el jugador pueda intentar de nuevo
		$DivisorPrincipal/PanelCartas.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _al_cancelar_creacion(dialogo: ConfirmationDialog) -> void:
	# Si el jugador cancela, quitamos el oscurecido y cerramos el diálogo
	$DivisorPrincipal/PanelCartas.modulate = Color(1.0, 1.0, 1.0, 1.0)
	dialogo.queue_free()
