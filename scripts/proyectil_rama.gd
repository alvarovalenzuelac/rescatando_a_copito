extends Area2D

@export var velocidad = 400.0
var direccion = Vector2.RIGHT 

func _ready():
	# Si la rama sale de la pantalla, se borra
	if has_node("VisibleOnScreenNotifier2D"):
		$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)
	
	# Conectar colisión
	body_entered.connect(_on_body_entered)
	
	# Si tienes un sprite animado girando
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("default")

func _physics_process(delta):
	position += direccion * velocidad * delta

func _on_body_entered(body):
	# Verificar si chocamos con Elías usando el grupo que acabamos de crear
	if body.is_in_group("jugador"):
		print("¡Golpe! Elías ha sido dañado.")
		# Aquí en el futuro pondremos: body.recibir_dano(1)
		queue_free()
	
	# Si choca con el suelo o paredes (TileMapLayer o TileMap antiguo)
	elif body is TileMapLayer or body is TileMap:
		queue_free()
