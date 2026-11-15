extends VBoxContainer
@onready var hoja_personaje: Control = $"../../.."
var personaje

@onready var ventaja_checkbox: CheckBox = $PanelAccion/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer/VentajaCheckbox
@onready var what_roll_label: Label = $PanelAccion/VBoxContainer/HBoxContainer/VBoxContainer/RollButton/VBoxContainer/HBoxContainer3/WhatRollLabel
@onready var resultado: Label = $PanelAccion/VBoxContainer/HBoxContainer/VBoxContainer/RollButton/VBoxContainer/HBoxContainer2/Resultado
@onready var historial: RichTextLabel = $"../PanelHistorialNotas/VBoxContainer/Historial"
var atributo_actual: String = "" 

@onready var f_atributo: Label = $PanelAccion/VBoxContainer/HboxContainer/VBoxContainer/FuerzaButton/VBoxContainer/HBoxContainer/Atributo
@onready var fue: Label = $PanelAccion/VBoxContainer/HboxContainer/VBoxContainer/FuerzaButton/VBoxContainer/HBoxContainer/Modificador

@onready var s_atributo: Label = $PanelAccion/VBoxContainer/HboxContainer/VBoxContainer/SabiduriaButton/VBoxContainer/HBoxContainer/Atributo
@onready var sab: Label = $PanelAccion/VBoxContainer/HboxContainer/VBoxContainer/SabiduriaButton/VBoxContainer/HBoxContainer/Modificador

@onready var d_atributo: Label = $PanelAccion/VBoxContainer/HboxContainer/VBoxContainer2/DestrezaButton/VBoxContainer/HBoxContainer/Atributo
@onready var des: Label = $PanelAccion/VBoxContainer/HboxContainer/VBoxContainer2/DestrezaButton/VBoxContainer/HBoxContainer/Modificador

@onready var i_atributo: Label = $PanelAccion/VBoxContainer/HboxContainer/VBoxContainer2/InteligenciaButton/VBoxContainer/HBoxContainer/Atributo
@onready var int_mod: Label = $PanelAccion/VBoxContainer/HboxContainer/VBoxContainer2/InteligenciaButton/VBoxContainer/HBoxContainer/Modificador

@onready var con_atributo: Label = $PanelAccion/VBoxContainer/HboxContainer/VBoxContainer3/ConstitucionButton/VBoxContainer/HBoxContainer/Atributo
@onready var con: Label = $PanelAccion/VBoxContainer/HboxContainer/VBoxContainer3/ConstitucionButton/VBoxContainer/HBoxContainer/Modificador

@onready var car_atributo: Label = $PanelAccion/VBoxContainer/HboxContainer/VBoxContainer3/CarismaButton/VBoxContainer/HBoxContainer/Atributo
@onready var car: Label = $PanelAccion/VBoxContainer/HboxContainer/VBoxContainer3/CarismaButton/VBoxContainer/HBoxContainer/Modificador

@onready var etiquetas_atr: Array[Label] = [
	f_atributo, d_atributo, con_atributo, s_atributo, i_atributo, car_atributo
]

@onready var etiquetas_mod: Array[Label] = [
	fue, des, con, sab, int_mod, car
]

const atributos: Array[String] = [
	"fuerza", "destreza", "constitucion", "sabiduria", "inteligencia", "carisma"
]

const Atributos = [
	"Fuerza", "Destreza", "Constitucion", "Sabiduria", "Inteligencia", "Carisma"
	]

@onready var d_2: Control = $PanelAccion/VBoxContainer/HBoxContainer/GridContainer/CasillaDadoD2
@onready var d_4: Control = $PanelAccion/VBoxContainer/HBoxContainer/GridContainer/CasillaDadoD4
@onready var d_6: Control = $PanelAccion/VBoxContainer/HBoxContainer/GridContainer/CasillaDadoD6
@onready var d_8: Control = $PanelAccion/VBoxContainer/HBoxContainer/GridContainer/CasillaDadoD8
@onready var d_10: Control = $PanelAccion/VBoxContainer/HBoxContainer/GridContainer/CasillaDadoD10
@onready var d_12: Control = $PanelAccion/VBoxContainer/HBoxContainer/GridContainer/CasillaDadoD12
@onready var d_20: Control = $PanelAccion/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer/CasillaDadoD20
var roll_pure_dice: Dictionary = {}
@onready var roll_button: Button = $PanelAccion/VBoxContainer/HBoxContainer/VBoxContainer/RollButton/VBoxContainer/HBoxContainer/RollButton

func setup():
	for i in range(6):
		etiquetas_atr[i].text = str(personaje.get(atributos[i]))
		etiquetas_mod[i].text =  {0: "+", -1: "", 1: "+"}[sign(personaje.modificador(atributos[i]))] + str(personaje.modificador(atributos[i]))
	
	d_2.selected.connect(_on_dice_selected)
	d_4.selected.connect(_on_dice_selected)
	d_6.selected.connect(_on_dice_selected)
	d_8.selected.connect(_on_dice_selected)
	d_10.selected.connect(_on_dice_selected)
	d_12.selected.connect(_on_dice_selected)
	d_20.selected.connect(_on_dice_selected)

func make_label_from_rpd():
	var nuevo_texto = ""
	
	# Si hay un atributo seleccionado, empezamos con su nombre
	if atributo_actual != "":
		nuevo_texto = atributo_actual
	
	# Si además hay dados seleccionados, los añadimos
	if roll_pure_dice != {}:
		var dados_str = ""
		for k in roll_pure_dice.keys():
			if roll_pure_dice[k] > 0:
				dados_str += str(roll_pure_dice[k]) + k + "+"
				
		# Quitamos el último "+"
		if dados_str != "":
			dados_str = dados_str.substr(0, dados_str.length() - 1)
			
		# Si ya había un atributo, ponemos un espacio entre el atributo y los dados
		if nuevo_texto != "":
			nuevo_texto += " " + dados_str
		else:
			nuevo_texto = dados_str
			
	what_roll_label.text = nuevo_texto
	
	# Actualizar el estado del botón Roll
	roll_button.disabled = (what_roll_label.text == "")
	
	# Sincronizar la cantidad visual en las casillas de los dados
	d_2.ground_cantidad(roll_pure_dice.get("D2", 0))
	d_4.ground_cantidad(roll_pure_dice.get("D4", 0))
	d_6.ground_cantidad(roll_pure_dice.get("D6", 0))
	d_8.ground_cantidad(roll_pure_dice.get("D8", 0))
	d_10.ground_cantidad(roll_pure_dice.get("D10", 0))
	d_12.ground_cantidad(roll_pure_dice.get("D12", 0))
	d_20.ground_cantidad(roll_pure_dice.get("D20", 0))
	
func _on_dice_selected(cantidad, dice_type):
	if cantidad == 0:
		roll_pure_dice.erase(dice_type)
	else:
		roll_pure_dice[dice_type] = cantidad
		atributo_actual = "" 
	
	make_label_from_rpd()
		
func _ready() -> void:
	await hoja_personaje.ready
	personaje = hoja_personaje.personaje
	setup()

func handle_atributo_pressed(atributo: String):
	var nombre_formateado = atributo.capitalize()
	
	if atributo_actual == nombre_formateado:
		atributo_actual = "" # Si tocas el mismo, lo desmarcas
	else:
		atributo_actual = nombre_formateado
		roll_pure_dice = {} # ¡AQUÍ ESTÁ EL TRUCO! Si tocas un atributo, borras los dados
		
	make_label_from_rpd()
		
func _on_fuerza_button_pressed() -> void:
	handle_atributo_pressed("fuerza")


func _on_sabiduria_button_pressed() -> void:
	handle_atributo_pressed("sabiduria")


func _on_destreza_button_pressed() -> void:
	handle_atributo_pressed("destreza")


func _on_inteligencia_button_pressed() -> void:
	handle_atributo_pressed("inteligencia")


func _on_constitucion_button_pressed() -> void:
	handle_atributo_pressed("constitucion")

	
func _on_carisma_button_pressed() -> void:
	handle_atributo_pressed("carisma")
	
func _on_ventaja_checkbox_toggled(toggled_on: bool) -> void:
	var texto_limpio = what_roll_label.text.replace(" V", "")
	
	if atributo_actual != "":
		# Es una tirada de atributo
		if toggled_on:
			what_roll_label.text = texto_limpio + " V"
		else:
			what_roll_label.text = texto_limpio
	else:
		# Es una tirada de dados puros
		if toggled_on:
			roll_pure_dice = {"D20": 1} # Forzamos 1D20
			make_label_from_rpd()
			what_roll_label.text += " V"
		else:
			roll_pure_dice = {}
			make_label_from_rpd()
			
	roll_button.disabled = (what_roll_label.text == "" or what_roll_label.text == " V")
	
func _on_roll_button_pressed() -> void:
	var texto_roll = what_roll_label.text.strip_edges()
	if texto_roll == "" or texto_roll == " V":
		return
		
	var resultado_final = 0
	var desglose_historial = ""
	var tiene_ventaja = " V" in texto_roll
	
	# CASO 1: TIRADA DE ATRIBUTO
	if atributo_actual != "":
		var nombre_atributo = atributo_actual.to_lower()
		var mod = personaje.modificador(nombre_atributo)
		
		var d20_1 = Dice.D20.roll()
		var d20_usado = d20_1
		var texto_dados = str(d20_1)
		
		if tiene_ventaja:
			var d20_2 = Dice.D20.roll()
			d20_usado = max(d20_1, d20_2)
			texto_dados = "[" + str(d20_1) + ", " + str(d20_2) + "] -> " + str(d20_usado) + " (V)"
			
		resultado_final = d20_usado + mod
		var signo_mod = "+" if mod >= 0 else ""
		desglose_historial = "%s: %s %s%s = %s" % [atributo_actual, texto_dados, signo_mod, str(mod), str(resultado_final)]
		
	# CASO 2: TIRADA DE DADOS PUROS
	else:
		for k in roll_pure_dice.keys():
			var cantidad = roll_pure_dice[k]
			var dado = Dice.get_dado_por_nombre(k)
			if dado != null:
				var tiradas = []
				for i in range(cantidad):
					tiradas.append(dado.roll())
				
				for t in tiradas:
					resultado_final += t
					
				var tiradas_str = str(tiradas).replace("[", "").replace("]", "")
				
				if desglose_historial != "":
					desglose_historial += " + "
				desglose_historial += "%d%s: %s" % [cantidad, k, tiradas_str]
				
		if desglose_historial != "":
			desglose_historial += " = " + str(resultado_final)
	
	# Mostrar resultado
	resultado.text = str(resultado_final)
	historial.append_text("- " + desglose_historial + "\n")
