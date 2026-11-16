# gestor_personajes.gd (Autoload)
extends Node

const DIRECTORIO := "user://cartas/"

func _ready() -> void:
	# Asegura que la carpeta exista
	DirAccess.make_dir_recursive_absolute(DIRECTORIO)

# Devuelve una lista con los nombres de archivo de todos los personajes guardados
func listar_cartas() -> Array[String]:
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
func guardar_carta(carta, id_carta: String) -> Error:
	if id_carta.is_empty():
		push_error("El id de la carta no puede estar vacío")
		return ERR_INVALID_PARAMETER
	if id_carta.contains("/") or id_carta.contains("\\"):
		push_error("El id contiene caracteres no permitidos: " + id_carta)
		return ERR_INVALID_PARAMETER
		
	var ruta := DIRECTORIO + id_carta + ".json"
	var datos = carta.a_diccionario()
	var json_string := JSON.stringify(datos, "\t") # Con indentación para legibilidad
	
	var archivo := FileAccess.open(ruta, FileAccess.WRITE)
	if archivo == null:
		push_error("No se pudo abrir el archivo para guardar: " + ruta)
		return FileAccess.get_open_error()
	
	archivo.store_string(json_string)
	archivo.close()
	return OK

# Carga un personaje por su id
func cargar_carta(id_carta: String) -> Carta:
	var ruta := DIRECTORIO + id_carta + ".json"
	if not FileAccess.file_exists(ruta):
		push_error("La carta no existe: " + id_carta)
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
	
	var carta := Carta.new()
	carta.desde_diccionario(datos)
	return carta

# Elimina un personaje
func eliminar_carta(id_carta: String) -> Error:
	var ruta := DIRECTORIO + id_carta + ".json"
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
		limpio = "carta"
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

# En GestorCarta.gd

func eliminar_carta_de_json(id_carta: String) -> void:
	# Solo permitimos esto si estamos en el editor (para evitar problemas en Android)
	if not OS.has_feature("editor"):
		return

	# Ruta real al cartas.json en tu disco duro
	var ruta_json = ProjectSettings.globalize_path("res://Cartas/cartas.json")
	
	if not FileAccess.file_exists(ruta_json):
		push_error("No se encontró el cartas.json en: " + ruta_json)
		return

	# 1. Leer el archivo
	var archivo_lectura = FileAccess.open(ruta_json, FileAccess.READ)
	var contenido = archivo_lectura.get_as_text()
	archivo_lectura.close()
	
	var datos = JSON.parse_string(contenido)
	if datos == null:
		push_error("El JSON es inválido.")
		return

	# 2. Buscar y eliminar la carta
	var nuevas_cartas := []
	var encontrada := false
	for carta in datos:
		if carta.get("id", "") != id_carta:
			nuevas_cartas.append(carta)
		else:
			encontrada = true

	if not encontrada:
		return # No estaba en el JSON (quizás era una carta creada por el usuario)

	# 3. Guardar el archivo modificado
	var archivo_escritura = FileAccess.open(ruta_json, FileAccess.WRITE)
	if archivo_escritura:
		archivo_escritura.store_string(JSON.stringify(nuevas_cartas, "\t"))
		archivo_escritura.close()
		print("Carta '", id_carta, "' eliminada del cartas.json original.")
	else:
		push_error("No se pudo escribir en el cartas.json (el editor podría tenerlo bloqueado).")

func guardar_carta_en_json(carta: Carta, id_carta: String) -> void:
	# Solo permitimos esto si estamos en el editor (para evitar problemas en Android)
	if not OS.has_feature("editor"):
		return

	var ruta_json = ProjectSettings.globalize_path("res://Cartas/cartas.json")
	
	if not FileAccess.file_exists(ruta_json):
		push_error("No se encontró el cartas.json en: " + ruta_json)
		return

	# 1. Leer el archivo actual
	var archivo_lectura = FileAccess.open(ruta_json, FileAccess.READ)
	var contenido = archivo_lectura.get_as_text()
	archivo_lectura.close()
	
	var datos = JSON.parse_string(contenido)
	if datos == null:
		datos = [] # Si está vacío o corrupto, empezamos un array nuevo

	# 2. Buscar si la carta ya existe
	var indice_existente = -1
	for i in range(datos.size()):
		if datos[i].get("id", "") == id_carta:
			indice_existente = i
			break

	var diccionario_carta = carta.a_diccionario()

	# 3. Actualizar o añadir la carta
	if indice_existente != -1:
		datos[indice_existente] = diccionario_carta # Reemplazar (Editar)
		print("Carta '", id_carta, "' actualizada en cartas.json.")
	else:
		datos.append(diccionario_carta) # Añadir al final (Crear)
		print("Carta '", id_carta, "' añadida a cartas.json.")

	# 4. Guardar el archivo modificado
	var archivo_escritura = FileAccess.open(ruta_json, FileAccess.WRITE)
	if archivo_escritura:
		archivo_escritura.store_string(JSON.stringify(datos, "\t"))
		archivo_escritura.close()
	else:
		push_error("No se pudo escribir en el cartas.json (el editor podría tenerlo bloqueado).")
# En GestorCarta.gd

func sincronizar_todo_con_json() -> void:
	if not OS.has_feature("editor"):
		push_error("Esto solo funciona en el editor de Godot.")
		return

	var ruta_json = ProjectSettings.globalize_path("res://Cartas/cartas.json")
	if not FileAccess.file_exists(ruta_json):
		push_error("No se encontró el cartas.json en: " + ruta_json)
		return

	# 1. Leer el JSON actual
	var archivo_lectura = FileAccess.open(ruta_json, FileAccess.READ)
	var datos = JSON.parse_string(archivo_lectura.get_as_text())
	archivo_lectura.close()
	
	if datos == null:
		datos = []

	# Crear un diccionario temporal para buscar rápido por ID (evita duplicados)
	var cartas_por_id = {}
	for c in datos:
		cartas_por_id[c.get("id", "")] = c

	# 2. Leer todas las cartas del usuario y actualizar el diccionario
	var cartas_usuario = listar_cartas()
	var count_actualizadas = 0
	var count_nuevas = 0

	for id_carta in cartas_usuario:
		var carta_user = cargar_carta(id_carta)
		if carta_user != null:
			var diccionario_user = carta_user.a_diccionario()
			
			if cartas_por_id.has(id_carta):
				cartas_por_id[id_carta] = diccionario_user
				count_actualizadas += 1
			else:
				cartas_por_id[id_carta] = diccionario_user
				count_nuevas += 1

	# 3. Convertir el diccionario de vuelta a un Array para guardarlo
	var datos_finales = []
	for c in cartas_por_id.values():
		datos_finales.append(c)

	# 4. Guardar el cartas.json actualizado
	var archivo_escritura = FileAccess.open(ruta_json, FileAccess.WRITE)
	if archivo_escritura:
		archivo_escritura.store_string(JSON.stringify(datos_finales, "\t"))
		archivo_escritura.close()
		print("¡Sincronización exitosa! Nuevas: ", count_nuevas, " | Actualizadas: ", count_actualizadas)
	else:
		push_error("No se pudo escribir en el cartas.json.")

	# 5. OPCIONAL: Borrar los archivos de user:// para forzar la resiembra
	# Descomenta estas líneas si quieres que el juego vuelva a leer desde el JSON
	var dir = DirAccess.open(DIRECTORIO)
	if dir:
		dir.list_dir_begin()
		var archivo = dir.get_next()
		while archivo != "":
			if archivo.ends_with(".json"):
				dir.remove(archivo)
			archivo = dir.get_next()
		dir.list_dir_end()
		print("Carpeta user://cartas/ limpiada.")
