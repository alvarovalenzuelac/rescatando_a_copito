extends StaticBody2D

@export var altura_suelo: float = 40.0
@onready var collision = $CollisionShape2D
# @onready var color_rect = $ColorRect  <-- Ya no usaremos esto para dibujar

func _ready() -> void:
	var pantalla = get_viewport_rect().size
	
	# 1. Posición (Altura correcta)
	position.y = pantalla.y - altura_suelo
	position.x = 0
	
	# 2. FÍSICA INFINITA
	# En lugar de RectangleShape2D, usamos esto:
	var shape = WorldBoundaryShape2D.new()
	shape.normal = Vector2.UP # La pared invisible apunta hacia arriba (es piso)
	collision.shape = shape
