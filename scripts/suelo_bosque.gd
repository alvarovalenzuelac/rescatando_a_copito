extends StaticBody2D

@export var altura_suelo: float = 40.0

@onready var color_rect = $ColorRect # Si vas a usar Parallax, puedes ocultar este nodo
@onready var collision = $CollisionShape2D

func _ready() -> void:
	var pantalla = get_viewport_rect().size
	
	# 1. Posicionamos el suelo en la parte baja de la pantalla
	position.y = pantalla.y - altura_suelo
	position.x = 0 
	
	# 2. FÍSICA INFINITA (El cambio clave)
	# En lugar de un Rectángulo que se acaba, usamos WorldBoundary
	var shape = WorldBoundaryShape2D.new()
	shape.normal = Vector2.UP # La línea apunta hacia arriba (el suelo)
	
	collision.shape = shape
	
	# La colisión se coloca en el origen del nodo (0,0 relativo al suelo)
	collision.position = Vector2.ZERO
	
	# OPCIONAL: Si quieres mantener el bloque verde visualmente por ahora
	# lo hacemos gigante, pero lo ideal es el Paso 2
	if color_rect:
		color_rect.size = Vector2(100000, altura_suelo) # Un parche temporal
