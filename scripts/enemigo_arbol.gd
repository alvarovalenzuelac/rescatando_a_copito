extends CharacterBody2D

# --- CONFIGURACIÓN ---
@export var escena_rama: PackedScene # ¡Arrastra proyectil_rama.tscn aquí en el Inspector!

# --- VARIABLES ---
# Obtenemos la gravedad directamente de la configuración del proyecto para evitar errores de 'Nil'
var gravedad = ProjectSettings.get_setting("physics/2d/default_gravity")

# --- REFERENCIAS ---
@onready var anim = $AnimatedSprite2D
@onready var timer_ataque = $TimerAtaque
@onready var area_deteccion = $AreaDeteccion

# --- ESTADOS ---
enum Estado { ARBOL, DESPERTANDO, ATACANDO, DURMIENDO }
var estado_actual = Estado.ARBOL
var objetivo: Node2D = null

func _ready():
	# Configuración inicial: Parece un árbol normal
	if anim.sprite_frames.has_animation("transformar"):
		anim.play("transformar")
		anim.frame = anim.sprite_frames.get_frame_count("transformar") - 1
		anim.pause()
	
	# Conexiones de señales
	area_deteccion.body_entered.connect(_on_vision_entered)
	area_deteccion.body_exited.connect(_on_vision_exited)
	anim.animation_finished.connect(_on_animation_finished)
	timer_ataque.timeout.connect(_on_timer_ataque_timeout)

func _physics_process(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravedad * delta
	
	# NO movemos velocity.x porque es una torreta estática
	move_and_slide()
	
	# Girar para mirar al jugador si estamos atacando
	if estado_actual == Estado.ATACANDO and objetivo:
		var direccion_x = sign(objetivo.global_position.x - global_position.x)
		if direccion_x != 0:
			flip_sprite(direccion_x)

# --- VISIÓN ---

func _on_vision_entered(body):
	if body.is_in_group("jugador"):
		objetivo = body
		if estado_actual == Estado.ARBOL:
			cambiar_estado(Estado.DESPERTANDO)
		elif estado_actual == Estado.DURMIENDO:
			cambiar_estado(Estado.DESPERTANDO)

func _on_vision_exited(body):
	if body == objetivo:
		objetivo = null
		if estado_actual == Estado.ATACANDO:
			cambiar_estado(Estado.DURMIENDO)

# --- MÁQUINA DE ESTADOS ---

func cambiar_estado(nuevo_estado):
	estado_actual = nuevo_estado
	
	match estado_actual:
		Estado.DESPERTANDO:
			print("¡Intruso! Despertando...")
			anim.play_backwards("transformar") # De Árbol a Monstruo
			
		Estado.ATACANDO:
			print("¡Ataque iniciado!")
			timer_ataque.start()
			_lanzar_ataque()
			
		Estado.DURMIENDO:
			print("Objetivo perdido. Durmiendo...")
			timer_ataque.stop()
			anim.play("transformar") # De Monstruo a Árbol
			
		Estado.ARBOL:
			anim.stop()

# --- ATAQUE Y PROYECTIL ---

func _on_timer_ataque_timeout():
	if estado_actual == Estado.ATACANDO and objetivo:
		_lanzar_ataque()
		timer_ataque.start()

func _lanzar_ataque():
	anim.play("lanzar_rama")

func spawn_proyectil():
	if not escena_rama:
		print("ERROR: No has asignado la escena del proyectil en el Inspector del enemigo.")
		return

	var nueva_rama = escena_rama.instantiate()
	# Ajusta este Vector2(0, -20) para que salga de la mano del árbol
	nueva_rama.global_position = global_position + Vector2(0, -20)
	
	# Decidir dirección
	var dir = -1 if anim.flip_h else 1
	nueva_rama.direccion = Vector2(dir, 0)
	
	# Añadir al nivel (no al enemigo)
	get_parent().add_child(nueva_rama)

# --- CONTROL ANIMACIONES ---

func _on_animation_finished():
	if anim.animation == "transformar":
		# Si terminó de reproducirse hacia atrás (llegó al frame 0)
		if estado_actual == Estado.DESPERTANDO:
			cambiar_estado(Estado.ATACANDO)
		# Si terminó de reproducirse normal
		elif estado_actual == Estado.DURMIENDO:
			cambiar_estado(Estado.ARBOL)
			
	elif anim.animation == "lanzar_rama":
		spawn_proyectil() # Disparamos justo al terminar la animación
		if estado_actual == Estado.ATACANDO:
			anim.play("idle") # Vuelve a estar quieto esperando el timer

func flip_sprite(dir):
	if dir > 0: anim.flip_h = false
	elif dir < 0: anim.flip_h = true
