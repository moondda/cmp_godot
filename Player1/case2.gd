extends Sprite

var bullet_speed = 600
var bullet = preload("res://Player1/ruler.tscn")
var onshot = true


func _ready(): #view toplevel
	set_as_toplevel(true)
	
func _physics_process(delta): #case2 position
	position.x = lerp(position.x, get_parent().position.x+5, 0.5)
	position.y = lerp(position.y, get_parent().position.y+25, 0.5)
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	shooting()
	
func shooting(): #bullet shooting
	if Input.is_action_pressed("shoot") and onshot and !Global.weapon and Global.health > 0:
		$shooting.play()
		var bullet_instance = bullet.instance()
		bullet_instance.rotation = rotation
		bullet_instance.global_position = $case2Position2D.global_position
		bullet_instance.apply_impulse(Vector2(),Vector2(bullet_speed,0).rotated(rotation))
		get_parent().add_child(bullet_instance)
		onshot = false
		yield(get_tree().create_timer(Global.bullet_term),"timeout")
		onshot = true
		
