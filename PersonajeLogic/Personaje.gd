# personaje.gd
class_name Personaje
extends Resource

@export var nombre: String = ""
@export var raza: String = ""
@export var nivel: int = 1
@export var dinero: int = 100
# Stats
@export var max_vida: int = 5
@export var vida: int = max_vida
@export var CA: int = 10
@export var max_hechizos: int = 10
@export var hechizos: int = 10

# Atributos principales
@export var fuerza: int = 10
@export var destreza: int = 10
@export var constitucion: int = 10
@export var inteligencia: int = 10
@export var sabiduria: int = 10
@export var carisma: int = 10

# Puntos de atributo (uno por atributo, se gastan en cartas de ese atributo)
@export var puntos_fuerza: int = 0
@export var puntos_destreza: int = 0
@export var puntos_constitucion: int = 0
@export var puntos_inteligencia: int = 0
@export var puntos_sabiduria: int = 0
@export var puntos_carisma: int = 0

# Ruta a la imagen guardada en user:// (opcional)
@export var cartas_equipadas: Array[String] = [] # Guarda solo IDs: ["ataque_sigiloso", "bola_de_fuego"]

func a_diccionario() -> Dictionary:
	return {
		"nombre": nombre,
		"raza": raza,
		"nivel": nivel,
		"max_vida": max_vida,
		"vida": vida,
		"CA": CA,
		"max_hechizos": max_hechizos,
		"hechizos": hechizos,
		"fuerza": fuerza,
		"destreza": destreza,
		"constitucion": constitucion,
		"inteligencia": inteligencia,
		"sabiduria": sabiduria,
		"carisma": carisma,
		"puntos_fuerza": puntos_fuerza,
		"puntos_destreza": puntos_destreza,
		"puntos_constitucion": puntos_constitucion,
		"puntos_inteligencia": puntos_inteligencia,
		"puntos_sabiduria": puntos_sabiduria,
		"puntos_carisma": puntos_carisma,
		"dinero": dinero,
		"cartas_equipadas": cartas_equipadas
	}

func desde_diccionario(datos: Dictionary) -> void:
	nombre = datos.get("nombre", "")
	raza = datos.get("raza", "")
	nivel = datos.get("nivel", 1)
	max_vida = datos.get("max_vida", 5)
	vida = datos.get("vida", 5)
	CA = datos.get("CA",10)
	max_hechizos = datos.get("max_hechizos",1)
	hechizos = datos.get("hechizos",1)
	fuerza = datos.get("fuerza", 10)
	destreza = datos.get("destreza", 10)
	constitucion = datos.get("constitucion", 10)
	inteligencia = datos.get("inteligencia", 10)
	sabiduria = datos.get("sabiduria", 10)
	carisma = datos.get("carisma", 10)
	puntos_fuerza = datos.get("puntos_fuerza", 0)
	puntos_destreza = datos.get("puntos_destreza", 0)
	puntos_constitucion = datos.get("puntos_constitucion", 0)
	puntos_inteligencia = datos.get("puntos_inteligencia", 0)
	puntos_sabiduria = datos.get("puntos_sabiduria", 0)
	puntos_carisma = datos.get("puntos_carisma", 0)
	dinero = datos.get("dinero", 0)
	cartas_equipadas.clear()
	for id in datos.get("cartas_equipadas", []):
		cartas_equipadas.append(str(id))

func modificador(atributo: String) -> int:
	var valor: int = get(atributo)
	return floori((valor - 10) / 2.0)

func modificador_total(atributo: String) -> int:
	var total = modificador(atributo) # Tu función base (Destreza 16 = +3)
	
	# Buscar si alguna carta equipada modifica este atributo
	for id_carta in cartas_equipadas:
		var carta = CompendioCartas.obtener_carta(id_carta)
		if carta.has("bonificadores_atributos") and carta["bonificadores_atributos"].has(atributo):
			total += carta["bonificadores_atributos"][atributo]
			
	return total
	
func puntos_de(atributo: String) -> int:
	return get("puntos_" + atributo)

func gastar_puntos(atributo: String, cantidad: int) -> bool:
	var actuales := puntos_de(atributo)
	if actuales < cantidad:
		return false
	set("puntos_" + atributo, actuales - cantidad)
	return true
