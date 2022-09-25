extends RigidBody2D

var bullet_damage = 15

func _ready(): #view toplevel
	set_as_toplevel(true)


func _on_bullet_body_entered(body): #check hit state
	if !body.is_in_group("player"):
		queue_free()

	if body.has_method("enemy_handle_hit"):
		body.enemy_handle_hit()
		queue_free()
