extends Control
@export var personaje_id: String
@onready var personaje: Personaje = GestorPersonaje.cargar_personaje(personaje_id)

@onready var back_button1: Button = $DivisorPrincipal/PanelInformacion/Subpaneles/Botones/BackButton1
@onready var listo_button1: Button = $DivisorPrincipal/PanelInformacion/Subpaneles/Botones/ListoButton1

@onready var cartas_contenedor: GridContainer = $DivisorPrincipal/PanelCartas/VSplitContainer/ScrollContainer/CartasContenedor
@onready var cartas_compradas: GridContainer = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer/ScrollContainer/CartasCompradas
@onready var carta_display: PanelContainer = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer2/CartaDisplay
const carta_button_scene = preload("res://Cartas/CartaButtonEntrada.tscn")
const CARTA = preload("res://Cartas/carta.tscn")
var carta_actual_id: String
@onready var boton_comprar: Button = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer2/BotonComprar
var cartas_compradas_ids: Array[String] = []


@onready var fuerza_label: Button = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/FDC/FormFuerza/FuerzaLabel
@onready var fuerza_input: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/FDC/FormFuerza/FuerzaInput
@onready var fue: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/FDC/FormFuerza/FUE

@onready var destreza_label: Button = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/FDC/FormDestreza/DestrezaLabel
@onready var destreza_input: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/FDC/FormDestreza/DestrezaInput
@onready var des: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/FDC/FormDestreza/DES

@onready var constitucion_label: Button = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/FDC/FormConstitucion/ConstitucionLabel
@onready var constitucion_input: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/FDC/FormConstitucion/ConstitucionInput
@onready var con: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/FDC/FormConstitucion/CON

@onready var sabiduria_label: Button = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/SIA/FormSabiduria/SabiduriaLabel
@onready var sabiduria_input: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/SIA/FormSabiduria/SabiduriaInput
@onready var sab: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/SIA/FormSabiduria/SAB

@onready var inteligencia_label: Button = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/SIA/FormInteligencia/InteligenciaLabel
@onready var inteligencia_input: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/SIA/FormInteligencia/InteligenciaInput
@onready var int_mod: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/SIA/FormInteligencia/INT

@onready var carisma_label: Button = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/SIA/FormCarisma/CarismaLabel
@onready var carisma_input: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/SIA/FormCarisma/CarismaInput
@onready var car: Label = $DivisorPrincipal/PanelInformacion/Subpaneles/Atributos/HSplitContainer/SIA/FormCarisma/CAR

@onready var pd_fue: Label = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer/PuntosDisponibles/HSplitContainer/PD_FDC/FormFuerza/PD_FUE
@onready var pd_des: Label = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer/PuntosDisponibles/HSplitContainer/PD_FDC/FormDestreza/PD_DES
@onready var pd_con: Label = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer/PuntosDisponibles/HSplitContainer/PD_FDC/FormConstitucion/PD_CON
@onready var pd_sab: Label = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer/PuntosDisponibles/HSplitContainer/PD_SIA/FormSabiduria/PD_SAB
@onready var pd_int: Label = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer/PuntosDisponibles/HSplitContainer/PD_SIA/FormInteligencia/PD_INT
@onready var pd_car: Label = $DivisorPrincipal/PanelCartas/VSplitContainer/HSplitContainer/VBoxContainer/PuntosDisponibles/HSplitContainer/PD_SIA/FormCarisma/PD_CAR

@onready var button_atr: Array[Button] = [
	fuerza_label, destreza_label, constitucion_label, sabiduria_label, inteligencia_label, carisma_label
]

@onready var etiquetas_atr: Array[Label] = [
	fuerza_input, destreza_input, constitucion_input, sabiduria_input, inteligencia_input, carisma_input
]

@onready var etiquetas_mod: Array[Label] = [
	fue, des, con, sab, int_mod, car
]

@onready var etiquetas_puntos: Array[Label] = [
	pd_fue, pd_des, pd_con, pd_sab, pd_int, pd_car
]

const atributos: Array[String] = [
	"fuerza", "destreza", "constitucion", "sabiduria", "inteligencia", "carisma"
]

var HOJA_PERSONAJE = load("res://PersonajeLogic/HojaPersonaje/hoja_personaje.tscn")


func _ready() -> void:
	for i in range(6):
		etiquetas_atr[i].text = str(personaje.get(atributos[i]))
		etiquetas_mod[i].text = str(personaje.modificador(atributos[i]))

func handle_button_pressed(atributo: String):
	for i in range(6):
		if atributos[i] == atributo:
			etiquetas_atr[i].text = str(personaje.get(atributos[i])+1)
			etiquetas_mod[i].text = str(floori((personaje.get(atributos[i])+1 - 10) / 2.0))
		else:
			etiquetas_atr[i].text = str(personaje.get(atributos[i]))
			etiquetas_mod[i].text = str(personaje.modificador(atributos[i]))
			
func _on_fuerza_label_pressed() -> void:
	handle_button_pressed("fuerza")

func _on_destreza_label_pressed() -> void:
	handle_button_pressed("destreza")


func _on_constitucion_label_pressed() -> void:
	handle_button_pressed("constitucion")


func _on_sabiduria_label_pressed() -> void:
	handle_button_pressed("sabiduria")


func _on_inteligencia_label_pressed() -> void:
	handle_button_pressed("inteligencia")

func _on_carisma_label_pressed() -> void:
	handle_button_pressed("carisma")

func _on_back_button_1_pressed() -> void:
	var HP = HOJA_PERSONAJE.instantiate()
	HP.personaje_id = personaje_id
	get_tree().change_scene_to_node(HP)

func actualizar_puntos_compra() -> void:
	# Los puntos disponibles se basan en el modificador de cada atributo final
	pd_fue.text = str(max(0,floori((int(fuerza_input.text) - 10) / 2.0) + personaje.get("puntos_fuerza")))
	pd_des.text = str(max(0,floori((int(destreza_input.text) - 10) / 2.0) + personaje.get("puntos_destreza")))
	pd_con.text = str(max(0,floori((int(constitucion_input.text) - 10) / 2.0) + personaje.get("puntos_constitucion")))
	pd_sab.text = str(max(0,floori((int(sabiduria_input.text) - 10) / 2.0) + personaje.get("puntos_sabiduria")))
	pd_int.text = str(max(0,floori((int(inteligencia_input.text) - 10) / 2.0) + personaje.get("puntos_inteligencia")))
	pd_car.text = str(max(0,floori((int(carisma_input.text) - 10) / 2.0) + personaje.get("puntos_carisma")))

func _on_listo_button_1_pressed() -> void:
	var atributos = {
		"fuerza": int(fuerza_input.text),
		"destreza": int(destreza_input.text),
		"constitucion": int(constitucion_input.text),
		"inteligencia": int(inteligencia_input.text),
		"sabiduria": int(sabiduria_input.text),
		"carisma": int(carisma_input.text)
	}
	# 5. Si todo está OK, actualizamos los labels con los valores finales (Base + Raza)
	# (Opcional, pero recomendado para que el jugador vea cómo quedó su personaje)

	# 6. Desbloquear la Fase 2 (Cartas)
	$DivisorPrincipal/PanelInformacion.modulate = Color(0.5, 0.5, 0.5, 1)
	$DivisorPrincipal/PanelCartas.modulate = Color(1.0, 1.0, 1.0, 1.0)
	listo_button1.disabled = true # Deshabilitar este botón para que no se vuelva a pulsar
	# Bloquear también los inputs de atributos
	for b in button_atr:
		b.disabled = true
		
	# Ahora sí, cargamos las cartas disponibles (usando los puntos restantes)
	# Al inicio de la Fase 2, no ha comprado nada, así que tiene sus puntos de modificador
	actualizar_puntos_compra()
	desplegar_cartas_disponibles()

func desplegar_cartas_disponibles():
	var puntos_compra: Dictionary = {
		"puntos_fuerza": int(pd_fue.text),
		"puntos_destreza": int(pd_des.text),
		"puntos_constitucion": int(pd_con.text),
		"puntos_sabiduria": int(pd_sab.text),
		"puntos_inteligencia": int(pd_int.text),
		"puntos_carisma": int(pd_car.text),
	}
	
	# Limpiamos el contenedor
	for hijo in cartas_contenedor.get_children():
		hijo.queue_free()
	
	var cartas = CompendioCartas.get_cartas_disponibles_up_level(puntos_compra)
	
	for carta in cartas:
		var cartaUI = carta_button_scene.instantiate()
		cartaUI.id = carta["id"]
		cartaUI.text = carta["titulo"]
		cartaUI.comprada = false # <-- AÑADIR ESTO
		
		# Conectamos las nuevas señales
		cartaUI.seleccionar.connect(_on_carta_seleccionada)
		cartaUI.comprar.connect(_on_carta_comprada)
		
		cartas_contenedor.add_child(cartaUI)

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
	for b in button_atr:
		b.disabled = true
		
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
	personaje.nivel += 1
	
	personaje.fuerza = int(fuerza_input.text)
	personaje.destreza = int(destreza_input.text)
	personaje.constitucion = int(constitucion_input.text)
	personaje.inteligencia = int(inteligencia_input.text)
	personaje.sabiduria = int(sabiduria_input.text)
	personaje.carisma = int(carisma_input.text)
	
	# 4. Asignar los puntos RESTANTES (los que no se gastaron en cartas)
	personaje.puntos_fuerza = int(pd_fue.text)
	personaje.puntos_destreza = int(pd_des.text)
	personaje.puntos_constitucion = int(pd_con.text)
	personaje.puntos_sabiduria = int(pd_sab.text)
	personaje.puntos_inteligencia = int(pd_int.text)
	personaje.puntos_carisma = int(pd_car.text)
	
	# 5. Asignar las cartas compradas
	print(personaje.cartas_equipadas)
	for carta_id in cartas_compradas_ids:
		print(carta_id)
		if not carta_id in personaje.cartas_equipadas:
			personaje.cartas_equipadas.append(carta_id)
	
	# 5.5 Reflejar cambios de las cartas en los atributos
	for atributo in ["fuerza", "destreza", "constitucion", "sabiduria", "inteligencia", "carisma"]:
		for id_carta in personaje.cartas_equipadas:
			var carta = CompendioCartas.obtener_carta(id_carta)
			if carta.has("bonificadores_atributos") and carta["bonificadores_atributos"].has(atributo):
				personaje.set(atributo,personaje.get(atributo) + carta["bonificadores_atributos"][atributo])
	
	# 6 Actualizar Stats
	personaje.max_vida += int(personaje.constitucion/2)
	personaje.vida = personaje.max_vida
	personaje.max_hechizos = 2*personaje.modificador("inteligencia")
	personaje.hechizos = personaje.max_hechizos
	personaje.CA = 10 + personaje.modificador("destreza")
	
	# 7. Generar ID y Guardar
	var error = GestorPersonaje.guardar_personaje(personaje, personaje_id)
	
	dialogo.queue_free()
	
	if error == OK:
		var HP = HOJA_PERSONAJE.instantiate()
		HP.personaje_id = personaje_id
		get_tree().change_scene_to_node(HP)
	else:
		_mostrar_error("Hubo un error al guardar el personaje.")
		# Si falla, quitamos el oscurecido para que el jugador pueda intentar de nuevo
		$DivisorPrincipal/PanelCartas.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _al_cancelar_creacion(dialogo: ConfirmationDialog) -> void:
	# Si el jugador cancela, quitamos el oscurecido y cerramos el diálogo
	$DivisorPrincipal/PanelCartas.modulate = Color(1.0, 1.0, 1.0, 1.0)
	dialogo.queue_free()
