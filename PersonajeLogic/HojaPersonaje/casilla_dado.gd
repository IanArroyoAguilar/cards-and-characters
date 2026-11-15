extends Control

@onready var boton: TextureButton = $Boton
@onready var borde: PanelContainer = $Borde

const D2 = preload("res://Assets/Icons/Dados/d2.svg")
const D4 = preload("res://Assets/Icons/Dados/d4.svg")
const D6 = preload("res://Assets/Icons/Dados/d6.svg")
const D8 = preload("res://Assets/Icons/Dados/d8.svg")
const D10 = preload("res://Assets/Icons/Dados/d10.svg")
const D12 = preload("res://Assets/Icons/Dados/d12.svg")
const D20 = preload("res://Assets/Icons/Dados/D20.svg")
@onready var IMAGENES = {
	"D2": D2, "D4": D4, "D6": D6,
	"D8": D8, "D10": D10, "D12": D12, "D20": D20
	}

@export var dice_type: String

@onready var cantidad_label: Label = $Control/Cantidad
@onready var up_button: TextureButton = $Control/UpButton
@onready var down_button: TextureButton = $Control/DownButton

var cantidad: int = 0
func ground_cantidad(valor):
	if valor:
		cantidad = valor
		cantidad = clampi(cantidad,0,9)
		cantidad_label.text = str(cantidad)
	
signal selected(cantidad: int, type: String)

func _ready() -> void:
	boton.texture_normal = IMAGENES[dice_type]

func _on_up_button_pressed() -> void:
	cantidad += 1
	cantidad = clampi(cantidad,0,9)
	cantidad_label.text = str(cantidad)
	emit_signal("selected",cantidad,dice_type)
	

func _on_down_button_pressed() -> void:
	cantidad -= 1
	cantidad = clampi(cantidad,0,9)
	cantidad_label.text = str(cantidad)
	emit_signal("selected",cantidad,dice_type)
	

func _on_boton_pressed() -> void:
	if cantidad == 1:
		cantidad = 0
	else:
		cantidad = 1
	cantidad_label.text = str(cantidad)
	emit_signal("selected",cantidad,dice_type)
	

func _on_boton_mouse_entered() -> void:
	var new_stylebox_normal = borde.get_theme_stylebox("panel").duplicate()
	new_stylebox_normal.border_color = Color("180091ff")
	borde.add_theme_stylebox_override("panel", new_stylebox_normal)
	
func _on_boton_mouse_exited() -> void:
	var new_stylebox_normal = borde.get_theme_stylebox("panel").duplicate()
	new_stylebox_normal.border_color = Color("000000")
	borde.add_theme_stylebox_override("panel", new_stylebox_normal)
