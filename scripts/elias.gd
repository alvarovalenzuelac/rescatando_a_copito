extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var screen_size: Vector2

# --------- VIDA ----------
@export var max_health: int = 100
var health: int = max_health
signal health_changed(current_health: int)
signal died   # ✅ señal para avisar al main que murió

# --------- DAÑO POR CAÍDA FUERTE ----------
@export var fall_damage_threshold: float = 600.0
@export var fall_damage_amount: int = 25

func _ready() -> void:
	screen_size = get_viewport_rect().size
	emit_signal("health_changed", health)

func _physics_process(delta: float) -> void:
	var was_on_floor_before := is_on_floor()

	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Salto
	if Input.is_action_just_pressed("mover_saltar") and is_on_floor():
		velocity.y = jump_velocity
		$SfxSalto.play()

	# Movimiento horizontal
	var direction := Input.get_axis("mover_izquierda", "mover_derecha")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	update_animations(direction)
	#position.x = clamp(position.x, 0, screen_size.x)

	var vertical_speed_before := velocity.y

	move_and_slide()

	# DAÑO POR CAÍDA
	if not was_on_floor_before and is_on_floor():
		if vertical_speed_before > fall_damage_threshold:
			print("Caída fuerte, velocidad:", vertical_speed_before)
			apply_damage(fall_damage_amount)

func update_animations(direction: float) -> void:
	if is_on_floor():
		if direction != 0:
			animated_sprite.play("caminar")
			animated_sprite.flip_h = (direction < 0)
		else:
			animated_sprite.stop()
			animated_sprite.frame = 0
	else:
		animated_sprite.play("saltar2")
		if direction != 0:
			animated_sprite.flip_h = (direction < 0)

# --------- LÓGICA DE VIDA ----------
func apply_damage(amount: int) -> void:
	health -= amount
	if health < 0:
		health = 0

	emit_signal("health_changed", health)
	print("Elías recibió daño. Vida:", health)

	if health <= 0:
		die()

func die() -> void:
	print("DEBUG: die() llamado en elias_2")   # 👈 DEBE salir en la consola
	emit_signal("died")                        # 👈 avisamos al main
	set_physics_process(false)
	set_process(false)
	# Si quieres animación de muerte:
	# animated_sprite.play("muerte")
