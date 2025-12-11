extends StaticBody2D

@export var altura_suelo: float = 40.0 # Grosor del suelo en pixeles

@onready var color_rect = $ColorRect
@onready var collision = $CollisionShape2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var pantalla = get_viewport_rect().size
	
	position.y = pantalla.y - altura_suelo
	position.x = 0
	
	color_rect.size = Vector2(pantalla.x, altura_suelo)
	color_rect.color = Color.DARK_GREEN
	
	var shape = RectangleShape2D.new()
	shape.size = Vector2(pantalla.x, altura_suelo)
	collision.shape = shape
	
	collision.position = Vector2(pantalla.x / 2, altura_suelo / 2)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
