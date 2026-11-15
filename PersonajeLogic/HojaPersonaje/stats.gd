extends VBoxContainer
@onready var hoja_personaje: Control = $"../../../../../.."

@onready var max_vida_label: Label = $Vida/maxVidaLabel
@onready var ac_label: Label = $AC/ACLabel
@onready var mana_label: Label = $Mana/ManaLabel
var mana_actual: int
var mana_maximo: int
var ac: int

@onready var ac_up_button: TextureButton = $AC/VBoxContainer/ACUpButton
@onready var ac_down_button: TextureButton = $AC/VBoxContainer/ACDownButton
@onready var mana_up_button: TextureButton = $Mana/VBoxContainer/ManaUpButton
@onready var mana_down_button: TextureButton = $Mana/VBoxContainer/ManaDownButton

func setup():
	max_vida_label.text = str(int(hoja_personaje.personaje.max_vida))
	mana_actual = hoja_personaje.personaje.hechizos
	mana_maximo = hoja_personaje.personaje.max_hechizos
	mana_label.text = str(mana_actual) + "/" + str(mana_maximo)
	ac = hoja_personaje.personaje.CA
	ac_label.text = str(ac)
	
func _ready() -> void:
	await hoja_personaje.ready
	setup()

func cambiar_personaje(campo, valor):
	hoja_personaje.personaje.set(campo, valor)
	GestorPersonaje.guardar_personaje(hoja_personaje.personaje,hoja_personaje.personaje_id)


func _on_ac_up_button_pressed() -> void:
	ac += 1
	ac = clampi(ac,0,30)
	cambiar_personaje("CA",ac)
	ac_label.text = str(ac)
	
func _on_ac_down_button_pressed() -> void:
	ac -= 1
	ac = clampi(ac,0,30)
	cambiar_personaje("CA",ac)
	ac_label.text = str(ac)

func _on_mana_up_button_pressed() -> void:
	mana_actual += 1
	mana_actual = clampi(mana_actual,0,mana_maximo)
	cambiar_personaje("hechizos",mana_actual)
	mana_label.text = str(mana_actual) + "/" + str(mana_maximo)

func _on_mana_down_button_pressed() -> void:
	mana_actual -= 1
	mana_actual = clampi(mana_actual,0,mana_maximo)
	cambiar_personaje("hechizos",mana_actual)
	mana_label.text = str(mana_actual) + "/" + str(mana_maximo)
