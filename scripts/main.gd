extends Node

@export var plataforma_scene: PackedScene

var pantalla_size
var altura_actual: float = 0.0    # altura de la última plataforma

@onready var player: Node = $elias_2
@onready var health_bar: ProgressBar = $CanvasLayer/BarraVida
@onready var game_over_screen: Control = $CanvasLayer/GameOverScreen
@onready var retry_button: Button = $CanvasLayer/GameOverScreen/Button

func _ready() -> void:
	randomize()

	pantalla_size = get_viewport().get_visible_rect().size
	altura_actual = pantalla_size.y - 100 # Empezar cerca del suelo

	print("DEBUG main.gd _ready()")
	print("Jugador:", player)
	print("BarraVida:", health_bar)

	# Inicializar barra de vida con valores del jugador
	if health_bar and player:
		health_bar.min_value = 0
		health_bar.max_value = player.max_health
		health_bar.value = player.health

		# Señal de cambio de vida
		player.health_changed.connect(_on_player_health_changed)

		# ✅ Señal de muerte
		player.died.connect(_on_player_died)

	# Pantalla de Game Over oculta al inicio
	if game_over_screen:
		game_over_screen.visible = false

	# Conectar botón "Reintentar"
	if retry_button:
		retry_button.pressed.connect(_on_retry_button_pressed)


func generar_plataforma() -> void:
	if plataforma_scene == null:
		print("plataforma_scene es null, asigna plataforma.tscn en el inspector")
		return

	var plat = plataforma_scene.instantiate()
	var x = randf_range(30, pantalla_size.x - 30)
	altura_actual -= randf_range(80, 120)
	plat.position = Vector2(x, altura_actual)
	add_child(plat)


func _on_player_health_changed(current_health: int) -> void:
	print("HUD recibió vida:", current_health)  # DEBUG
	if health_bar:
		health_bar.value = current_health


func _on_player_died() -> void:
	print("MAIN: llegó señal de que Elías murió")

	if game_over_screen:
		game_over_screen.visible = true

	# Pausar el juego (menos la UI)
	get_tree().paused = true
	# Recuerda poner pause_mode = PROCESS al CanvasLayer o GameOverScreen


func _on_retry_button_pressed() -> void:
	print("Reintentar presionado")
	get_tree().paused = false
	get_tree().reload_current_scene()
