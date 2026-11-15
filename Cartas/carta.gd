extends Control


# Aqui solo datos visuales
@export var titulo: String = ""
@export var tipo: String = ""
@export var subtipo: String = ""

@export var costo: Dictionary = {
	"puntos_fuerza": 0,
	"puntos_destreza": 0,
	"puntos_constitucion": 0,
	"puntos_sabiduria": 0,
	"puntos_inteligencia": 0,
	"puntos_carisma": 0,
	"dinero": 0
	}

@export var descripcion: String = ""

# Elementos Visuales
@onready var titulo_label: Label = $PanelContainer/Divisor/Header/Titulo
@onready var costo_label: Label = $PanelContainer/Divisor/Header/Costo
@onready var descripcion_texto: RichTextLabel = $PanelContainer/Divisor/Cuerpo/Divisor/DescripcionTexto
@onready var tipo_label: Label = $PanelContainer/Divisor/Tailer/VBoxContainer/Separador/TipoLabel
@onready var subtipo_label: Label = $PanelContainer/Divisor/Tailer/VBoxContainer/Separador/SubtipoLabel

func make_costo_label(costo_arg) -> String:
	const etiquetas: Dictionary = {
		"puntos_fuerza": "FUE",
		"puntos_destreza": "DES",
		"puntos_constitucion": "CON",
		"puntos_sabiduria": "SAB",
		"puntos_inteligencia": "INT",
		"puntos_carisma": "CAR",
		"dinero": "$"
	}
	var label := ""
	for c in costo_arg.keys():
		if costo_arg[c] > 0:
			label += str(costo_arg[c]) + " " + etiquetas[c]
			label += "\n"
			
	return label

func reset_visuales():
	titulo = ""
	tipo = ""
	subtipo = ""
	descripcion = ""
	costo = {
		"puntos_fuerza": 0,
		"puntos_destreza": 0,
		"puntos_constitucion": 0,
		"puntos_sabiduria": 0,
		"puntos_inteligencia": 0,
		"puntos_carisma": 0,
		"dinero": 0
		}

func cargar_visuales(datos: Dictionary) -> void:
	reset_visuales()
	titulo = datos.get("titulo", "")
	tipo = datos.get("tipo", "")
	subtipo = datos.get("subtipo", "")
	costo = datos.get("costo", costo)
	descripcion = datos.get("descripcion", "")

	for k in costo.keys():
		costo[k] = int(costo[k])
		
	titulo_label.text = titulo
	tipo_label.text = tipo
	subtipo_label.text = subtipo
	descripcion_texto.text = descripcion
	costo_label.text = make_costo_label(costo)
	
	
