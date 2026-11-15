class_name Carta
extends Resource

const TIPOS = ["Habilidad", "Hechizo", "Equipamiento", "Consumible"]
const SUBTIPOS = {
	"Habilidad":["Pasiva", "Activa"],
	"Hechizo":["Pack", "Singular"],
	"Equipamiento":["Arma", "Armadura"],
	"Consumible":["Comestible", "Usable"]
	}

@export var id: String = "" # Ej: "ataque_sigiloso"

# Literales Filtrables
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
	"dinero": 0,
	}

# Literales No filtrables
@export var descripcion: String = ""

# Booleanos
@export var unica: bool = false

# Especiales
@export var bonificadores_atributos: Dictionary = {} # Ej: {"destreza": 2, "fuerza": -1}

func desde_diccionario(datos: Dictionary) -> void:
	id = datos.get("id", "") 
	titulo = datos.get("titulo", "")
	tipo = datos.get("tipo", "")
	subtipo = datos.get("subtipo", "")
	costo = datos.get("costo", costo)
	descripcion = datos.get("descripcion", "")
	unica = datos.get("unica",true)
	bonificadores_atributos = datos.get("bonificadores_atributos", "")

func a_diccionario() -> Dictionary:
	return {
		"id": id,
		"titulo": titulo,
		"tipo": tipo,
		"subtipo": subtipo,
		"costo": costo,
		"descripcion": descripcion,
		"unica": unica,
		"bonificadores_atributos": bonificadores_atributos,
	}

func _ready() -> void:
	pass
