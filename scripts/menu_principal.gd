extends Control

func _ready():
	# Conectamos las señales de los botones (si no quieres hacerlo manual desde el editor)
	# Asumiendo que tus botones se llaman "BotonJugar" y "BotonSalir" en el árbol
	# Si no, ajusta los nombres aquí abajo:
	$CenterContainer/VBoxContainer/BotonJugar.pressed.connect(iniciar_juego)
	$CenterContainer/VBoxContainer/BotonSalir.pressed.connect(salir_juego)

func iniciar_juego():
	# Cambia "res://escenas/niveles/main.tscn" por la ruta REAL de tu nivel 1
	get_tree().change_scene_to_file("res://escenas/niveles/escena_prueba.tscn")

func salir_juego():
	# Cierra el juego
	get_tree().quit()
