#extends Node2D
#
#@onready var tilemap = $TileMapLayer
#
## Configura aquí las coordenadas de tus tiles (Vector2i)
#var tile_izq = Vector2i(0, 3)
#var tile_centro = Vector2i(1, 3)
#var tile_der = Vector2i(2, 3)
#
#var source_id = 0 # Generalmente es 0 si solo tienes una imagen cargada
## Called when the node enters the scene tree for the first time.
#func _ready():
	## Elegir un ancho aleatorio (ej. entre 2 y 5 bloques de 16px)
	#var ancho_bloques = randi_range(2, 5)
	#construir_plataforma(ancho_bloques)
#
#func construir_plataforma(ancho):
	#tilemap.clear()
	#
	## Para centrar la plataforma: empezamos en negativo
	#var inicio_x = -int(ancho / 2)
	#
	## 1. Dibujar Borde Izquierdo
	#tilemap.set_cell(Vector2i(inicio_x, 0), source_id, tile_izq)
	#
	## 2. Dibujar Centro (Bucle)
	#for i in range(1, ancho - 1):
		#tilemap.set_cell(Vector2i(inicio_x + i, 0), source_id, tile_centro)
		#
	## 3. Dibujar Borde Derecho
	#tilemap.set_cell(Vector2i(inicio_x + ancho - 1, 0), source_id, tile_der)
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
