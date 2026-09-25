extends CharacterBody2D

# === MOVIMENTO MARTE ===
const SPEED = 100.0
const JUMP_FORCE = -200.0
var gravity = 300.0

# === LASER ===
const LASER = preload("res://laser.tscn")
@onready var ponto_tiro: Marker2D = $PontoTiro
var direcao_player: float = 1.0

# === OXIGÊNIO ===
var oxigenio_maximo: int = 100
var oxigenio_atual: int = 100
var perda_por_segundo: int = 1
var recuperacao_capsula: int = 20
var tem_nucleo: bool = false
var ja_morreu: bool = false

# === NÓS ===
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var barra_oxigenio: ProgressBar = $CanvasLayer/ProgressBar
@onready var oxygen_bar: AnimatedSprite2D = $CanvasLayer/OxygenBar
@onready var label_oxigenio: Label = $CanvasLayer/LabelOxigenio
@onready var timer_oxigenio: Timer = $Timer

func _ready() -> void:
	timer_oxigenio.wait_time = 0.25
	timer_oxigenio.one_shot = false

	if not timer_oxigenio.timeout.is_connected(_on_timer_timeout):
		timer_oxigenio.timeout.connect(_on_timer_timeout)

	timer_oxigenio.start()
	oxigenio_atual = oxigenio_maximo
	atualizar_ui_oxigenio()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE

	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
		direcao_player = direction
		anim.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("atirar"):
		atirar()

	move_and_slide()

	var anim_name := "idle"

	if not is_on_floor():
		anim_name = "jump" if velocity.y < 0 else "fall"
	elif direction != 0:
		anim_name = "run"

	if anim.animation != anim_name:
		anim.play(anim_name)

	if not ja_morreu and global_position.y > 1000:
		game_over()

func atirar() -> void:
	var laser = LASER.instantiate()
	get_tree().current_scene.add_child(laser)
	laser.global_position = ponto_tiro.global_position
	laser.definir_direcao(direcao_player)

func _on_timer_timeout() -> void:
	if ja_morreu:
		return

	oxigenio_atual -= perda_por_segundo
	oxigenio_atual = max(oxigenio_atual, 0)
	atualizar_ui_oxigenio()

	if oxigenio_atual <= 0:
		game_over()

func atualizar_ui_oxigenio() -> void:
	if barra_oxigenio:
		barra_oxigenio.max_value = oxigenio_maximo
		barra_oxigenio.value = oxigenio_atual

	if label_oxigenio:
		label_oxigenio.text = str(oxigenio_atual) + "/" + str(oxigenio_maximo)

	if oxygen_bar:
		var porcentagem := float(oxigenio_atual) / float(oxigenio_maximo)
		var frame_oxigenio := int(round((1.0 - porcentagem) * 15.0))
		oxygen_bar.frame = clamp(frame_oxigenio, 0, 15)

func recuperar_oxigenio(quantidade: int = recuperacao_capsula) -> void:
	if ja_morreu:
		return

	oxigenio_atual = min(oxigenio_atual + quantidade, oxigenio_maximo)
	atualizar_ui_oxigenio()

func _on_capsula_body_entered(body: Node) -> void:
	if body == self:
		recuperar_oxigenio()

func receber_dano_oxigenio(quantidade: int) -> void:
	if ja_morreu:
		return

	oxigenio_atual = max(oxigenio_atual - quantidade, 0)
	atualizar_ui_oxigenio()

	if oxigenio_atual <= 0:
		game_over()

func game_over() -> void:
	if ja_morreu:
		return

	ja_morreu = true
	timer_oxigenio.stop()
	get_tree().change_scene_to_file("res://Cenas/game_over.tscn")
