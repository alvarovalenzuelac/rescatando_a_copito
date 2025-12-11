#extends Node
#@export var plataforma_scene: PackedScene
#
## Called when the node enters the scene tree for the first time.
#var pantalla_size
#var altura_actual = 0 # Variable para recordar la altura de la última plataforma
#
#func _ready():
	#pantalla_size = get_viewport().get_visible_rect().size
	#altura_actual = pantalla_size.y - 100 # Empezar cerca del suelo
	#
	## Generar las primeras 20
	#for i in range(20):
		#generar_plataforma()
#
#func generar_plataforma():
	#var plat = plataforma_scene.instantiate()
	#
	## Posición X: Aleatoria dentro de la pantalla (con margen de 30px)
	#var x = randf_range(30, pantalla_size.x - 30)
	#
	## Posición Y: Subimos entre 80 y 120 pixeles respecto a la anterior
	#altura_actual -= randf_range(80, 120) 
	#
	#plat.position = Vector2(x, altura_actual)
	#add_child(plat)
