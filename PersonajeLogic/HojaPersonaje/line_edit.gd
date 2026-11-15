extends LineEdit

@onready var hoja_personaje: Control = $"../../../../../../../../.."
var max_vida: int = 8
var vida: int = 0
var vieja_vida: int = vida
var temp: Timer


func _negar_escritura(line_edit: LineEdit):
	var posicion_cursor = line_edit.caret_column
	line_edit.text = line_edit.text.substr(0, posicion_cursor - 1) + line_edit.text.substr(posicion_cursor)
	line_edit.caret_column = posicion_cursor - 1
	return
		
func _filtrar_solo_numeros(line_edit: LineEdit, new_text: String) -> void:
	# Si el texto está vacío, lo dejamos así (para permitir borrar)
	# Comprobamos si el texto es un número válido
	if not new_text.is_valid_int():
		_negar_escritura(line_edit)
	
func _ready() -> void:
	await hoja_personaje.ready
	max_vida = hoja_personaje.personaje.max_vida
	vida = hoja_personaje.personaje.vida
	
	text = str(clampi(vida,0,max_vida))
	
	temp = Timer.new()
	temp.wait_time = 5.0
	temp.one_shot = true
	add_child(temp)
	temp.timeout.connect(_on_temp_timeout)
	
func _on_text_changed(new_text: String) -> void:
	if new_text == "":
		return
	_filtrar_solo_numeros(self,new_text)
	vida = int(new_text)
	vida = clampi(vida,0,max_vida)
	hoja_personaje.personaje.vida = vida
	GestorPersonaje.guardar_personaje(hoja_personaje.personaje,hoja_personaje.personaje_id)

func _on_focus_entered() -> void:
	temp.start()

func _on_temp_timeout():
	self.release_focus()
