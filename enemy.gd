extends CharacterBody2D

var dir = 1
var velocidade = 50.0
var dano = 20

func _physics_process(_delta):
	velocity.x = dir * velocidade
	move_and_slide()

	if $WallCheck.is_colliding():
		dir *= -1
		scale.x *= -1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("receber_dano_oxigenio"):
		body.receber_dano_oxigenio(dano)
