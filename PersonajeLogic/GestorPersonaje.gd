# gestor_personajes.gd (Autoload)
extends Node

const DIRECTORIO := "user://personajes/"

func _ready() -> void:
	# Asegura que la carpeta exista
	DirAccess.make_dir_recursive_absolute(DIRECTORIO)

func quitar_carta(id_personaje, id_carta):
	var personaje = GestorPersonaje.cargar_personaje(id_personaje)
	var CartasPersonaje = personaje["cartas_equipadas"]
	CartasPersonaje.erase(id_carta)
	personaje["cartas_equipadas"] = CartasPersonaje
	guardar_personaje(personaje,id_personaje)
	
# Devuelve una lista con los nombres de archivo de todos los personajes guardados
func listar_personajes() -> Array[String]:
	var lista: Array[String] = []
	var dir := DirAccess.open(DIRECTORIO)
	if dir:
		dir.list_dir_begin()
		var archivo := dir.get_next()
		while archivo != "":
			if archivo.ends_with(".json"):
				lista.append(archivo.get_basename()) # Sin extensión
			archivo = dir.get_next()
		dir.list_dir_end()
	return lista

# Guarda un personaje. El identificador será el nombre del archivo (ej: "mi_personaje")
func guardar_personaje(personaje: Personaje, id_personaje: String) -> Error:
	if id_personaje.is_empty():
		push_error("El id del personaje no puede estar vacío")
		return ERR_INVALID_PARAMETER
	if id_personaje.contains("/") or id_personaje.contains("\\"):
		push_error("El id contiene caracteres no permitidos: " + id_personaje)
		return ERR_INVALID_PARAMETER
		
	var ruta := DIRECTORIO + id_personaje + ".json"
	var datos := personaje.a_diccionario()
	var json_string := JSON.stringify(datos, "\t") # Con indentación para legibilidad
	
	var archivo := FileAccess.open(ruta, FileAccess.WRITE)
	if archivo == null:
		push_error("No se pudo abrir el archivo para guardar: " + ruta)
		return FileAccess.get_open_error()
	
	archivo.store_string(json_string)
	archivo.close()
	return OK

# Carga un personaje por su id
func cargar_personaje(id_personaje: String) -> Personaje:
	var ruta := DIRECTORIO + id_personaje + ".json"
	if not FileAccess.file_exists(ruta):
		push_error("El personaje no existe: " + id_personaje)
		return null
	
	var archivo := FileAccess.open(ruta, FileAccess.READ)
	if archivo == null:
		push_error("No se pudo leer el archivo: " + ruta)
		return null
	
	var contenido := archivo.get_as_text()
	archivo.close()
	
	var datos = JSON.parse_string(contenido)
	if datos == null:
		push_error("JSON inválido en: " + ruta)
		return null
	
	var personaje := Personaje.new()
	personaje.desde_diccionario(datos)
	return personaje

# Elimina un personaje
func eliminar_personaje(id_personaje: String) -> Error:
	var ruta := DIRECTORIO + id_personaje + ".json"
	if FileAccess.file_exists(ruta):
		return DirAccess.remove_absolute(ruta)
	return OK
	
# Sanitiza un nombre para usarlo en un nombre de archivo
func _sanitizar_nombre(texto: String) -> String:
	var resultado := texto.strip_edges().to_lower()
	# Reemplaza tildes y ñ por sus equivalentes sin acento
	var reemplazos := {
		"á":"a", "é":"e", "í":"i", "ó":"o", "ú":"u", "ü":"u", "ñ":"n",
		"à":"a", "è":"e", "ì":"i", "ò":"o", "ù":"u",
		"ä":"a", "ë":"e", "ï":"i", "ö":"o",
	}
	for original in reemplazos:
		resultado = resultado.replace(original, reemplazos[original])
	# Solo letras, números, guiones y guiones bajos
	var limpio := ""
	for c in resultado:
		if c.is_valid_ascii_identifier() or c == "_" or c == "-" or c.is_valid_int():
			limpio += c
		elif c == " ":
			limpio += "_"
	limpio = limpio.strip_edges().lstrip("_").rstrip("_")
	if limpio.is_empty():
		limpio = "personaje"
	return limpio

# Encuentra el menor número libre para un nombre dado
func _siguiente_numero_libre(nombre_sanitizado: String) -> int:
	var n := 0
	while FileAccess.file_exists(DIRECTORIO + str(n) + "_" + nombre_sanitizado + ".json"):
		n += 1
	return n

# Genera un id único: "<numero>_<nombre_sanitizado>"
func generar_id(nombre: String) -> String:
	var sanitizado := _sanitizar_nombre(nombre)
	var numero := _siguiente_numero_libre(sanitizado)
	return str(numero) + "_" + sanitizado
