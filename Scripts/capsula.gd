extends Area2D

signal capsula_coletada

@onready var som_oxigenio: AudioStreamPlayer = $SomOxigenio

var coletada: bool = false

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if coletada:
		return

	if body.has_method("recuperar_oxigenio"):
		coletada = true

		body.recuperar_oxigenio()
		emit_signal("capsula_coletada")

		# Esconde a cápsula e desativa a colisão
		visible = false
		$CollisionShape2D.set_deferred("disabled", true)

		# Toca o som antes de destruir
		som_oxigenio.play()
		await som_oxigenio.finished

		queue_free()
