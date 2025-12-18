extends CharacterBody2D

# Configuración
@export var velocidad_patrulla = 50.0
@export var velocidad_persecucion = 100.0
@export var gravedad = 980.0

# Referencias
@onready var anim = $AnimatedSprite2D

# Estados del enemigo
enum Estado { PATRULLAR, PERSEGUIR, ATACAR }
var estado_actual = Estado.PATRULLAR

# Variables de lógica
var objetivo: Node2D = null  # Aquí guardaremos a Elías cuando lo veamos
var direccion_patrulla = 1   # 1 es derecha, -1 es izquierda
var tiempo_cambio_patrulla = 0.0

func _ready():
	# Conectamos la visión (Asegúrate de que el Area2D se llame "AreaDeteccion")
	$AreaDeteccion.body_entered.connect(_on_vision_body_entered)
	$AreaDeteccion.body_exited.connect(_on_vision_body_exited)
	anim.play("correr") # O "idle" si prefieres que empiece quieto

func _physics_process(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravedad * delta

	# Máquina de Estados: ¿Qué debo hacer ahora?
	match estado_actual:
		Estado.PATRULLAR:
			comportamiento_patrulla(delta)
		Estado.PERSEGUIR:
			comportamiento_persecucion(delta)
		Estado.ATACAR:
			comportamiento_ataque()

	move_and_slide()

# --- COMPORTAMIENTOS ---

func comportamiento_patrulla(delta):
	# Caminar en una dirección
	velocity.x = direccion_patrulla * velocidad_patrulla
	anim.play("correr")
	
	# Girar sprite según dirección
	flip_sprite(direccion_patrulla)
	
	# Detectar paredes o bordes para dar la vuelta (Lógica simple)
	if is_on_wall():
		direccion_patrulla *= -1 # Invertir dirección

func comportamiento_persecucion(delta):
	if objetivo:
		# Calcular dirección hacia Elías
		var direccion_hacia_jugador = (objetivo.global_position - global_position).normalized()
		
		# Solo nos interesa X (izquierda/derecha)
		var dir_x = sign(direccion_hacia_jugador.x)
		
		velocity.x = dir_x * velocidad_persecucion
		anim.play("correr") # O una anim de correr más rápido/agresivo
		flip_sprite(dir_x)
		
		# Si está muy cerca, atacar (opcional, distancia simple)
		if global_position.distance_to(objetivo.global_position) < 50:
			estado_actual = Estado.ATACAR

func comportamiento_ataque():
	velocity.x = 0 # Detenerse para atacar
	anim.play("lanzar_rama")
	# Aquí luego agregaremos la lógica para crear la bala (instanciar rama)

# --- UTILIDADES ---

func flip_sprite(dir):
	if dir > 0:
		anim.flip_h = false # Mirar derecha
	elif dir < 0:
		anim.flip_h = true  # Mirar izquierda

# --- SEÑALES (LOS OJOS) ---

func _on_vision_body_entered(body):
	# Verificamos si es Elías. Asegúrate de que tu personaje esté en un Grupo "jugador"
	# O que el nodo se llame "Elias"
	if body.name == "Elias": 
		objetivo = body
		estado_actual = Estado.PERSEGUIR
		print("¡Te vi, Elías!")

func _on_vision_body_exited(body):
	if body == objetivo:
		objetivo = null
		estado_actual = Estado.PATRULLAR
		print("Se escapó...")
