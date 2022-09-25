extends Area2D

var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var player = null
const speed = 200

export(int) var damage = 20

func _process(delta): #bullet option 
	position += transform.x * speed * delta

func _on_KillTimer_timeout():
	queue_free()



#func _on_Bullet_body_entered(body): #damage
#	if body.is_in_group("player"):
#		Global.health -= 2
#		queue_free()
