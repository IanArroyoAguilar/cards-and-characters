extends Node

var todas_las_cartas: Dictionary = {}

func _ready() -> void:
	# 1. Comprobamos si es la primera vez que se abre el juego
	# (Si no hay archivos en user://cartas/, la lista estará vacía)
	if GestorCarta.listar_cartas().is_empty():
		_sembrar_cartas_desde_json()
	
	# 2. Cargamos todas las cartas desde los archivos individuales (user://)
	cargar_todas_las_cartas()

func _sembrar_cartas_desde_json() -> void:
	print("Instalación detectada: Creando cartas individuales desde el JSON original...")
	var archivo = FileAccess.open("res://Cartas/cartas.json", FileAccess.READ)
	
	if archivo == null:
		push_error("ERROR CRÍTICO: No se encontró el cartas.json original en res://Cartas/")
		return
		
	var datos = JSON.parse_string(archivo.get_as_text())
	archivo.close()
	
	if datos == null:
		push_error("El cartas.json tiene un formato inválido.")
		return
		
	for c in datos:
		var nueva_carta = Carta.new()
		nueva_carta.desde_diccionario(c)
		
		# Usamos el ID que ya viene en el JSON (ej. "pasiva_arma_arrojadiza")
		# Si no tiene, le generamos uno con el título.
		var id = c.get("id", GestorCarta.generar_id(c.get("titulo", "carta")))
		
		# Guardamos el archivo individual en user://cartas/
		GestorCarta.guardar_carta(nueva_carta, id)
		
	print("Sembrado completado. Se crearon ", datos.size(), " cartas.")

func cargar_todas_las_cartas() -> void:
	todas_las_cartas.clear()
	var lista_ids = GestorCarta.listar_cartas()
	
	for id_carta in lista_ids:
		var carta: Carta = GestorCarta.cargar_carta(id_carta)
		if carta != null:
			# Guardamos los datos como Diccionario para que el resto del juego lo lea fácil
			todas_las_cartas[id_carta] = carta.a_diccionario()
			
	print("Compendio cargado con ", todas_las_cartas.size(), " cartas desde user://")

func obtener_carta(id: String) -> Dictionary:
	return todas_las_cartas.get(id, {})

func get_cartas_disponibles(puntos: Dictionary) -> Array:
	const costos: Array[String] = [
		"puntos_fuerza", "puntos_destreza", "puntos_constitucion",
		"puntos_sabiduria", "puntos_inteligencia", "puntos_carisma", "dinero"
	]
	var cartas_disponibles := []
	for carta_key in todas_las_cartas.keys():
		var carta = todas_las_cartas[carta_key]
		var es_comprable = true
		
		for costo in costos:
			if carta["costo"].has(costo):
				if carta["costo"][costo] > puntos[costo]:
					es_comprable = false
					break # Si falla un costo, ya no se puede comprar, rompemos el bucle
					
		if es_comprable:
			cartas_disponibles.append(carta)
			
	return cartas_disponibles

func get_cartas_disponibles_up_level(puntos: Dictionary) -> Array:
	const costos: Array[String] = [
		"puntos_fuerza", "puntos_destreza", "puntos_constitucion",
		"puntos_sabiduria", "puntos_inteligencia", "puntos_carisma"
	]
	var cartas_disponibles := []
	for carta_key in todas_las_cartas.keys():
		var carta = todas_las_cartas[carta_key]
		if carta["tipo"] in ["Consumible", "Equipamiento"]:
			continue
		var es_comprable = true
		
		for costo in costos:
			if carta["costo"].has(costo):
				if carta["costo"][costo] > puntos[costo]:
					es_comprable = false
					break # Si falla un costo, ya no se puede comprar, rompemos el bucle
					
		if es_comprable:
			cartas_disponibles.append(carta)
			
	return cartas_disponibles	
			
			
