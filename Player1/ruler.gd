extends RigidBody2D

var bullet_damage = 20

func _ready():# view toplevel
	set_as_toplevel(true)

func _on_ruler_body_entered(body): #ruler hit check
	if !body.is_in_group("player1"):
		queue_free()

	if body.has_method("enemy_handle_hit"):
		body.enemy_handle_hit()
		queue_free()
