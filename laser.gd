extends Area2D

@export var velocidade: float = 700.0
var direcao: float = 1.0


func _process(delta: float) -> void:
	position.x += velocidade * direcao * delta


func definir_direcao(nova_direcao: float) -> void:
	direcao = nova_direcao

	if direcao < 0:
		$Sprite2D.flip_h = true


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("inimigo"):
		body.queue_free()
		queue_free()
