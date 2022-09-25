extends KinematicBody2D

const bullet_scene = preload("res://Monster/M_Bullet.tscn")
onready var shoot_timer = $ShootTimer
onready var rotater = $Rotater

const rotate_speed = 200 #options of spawn and number of bullet
const shooter_timer_wait_time = 0.1
const spawn_point_count = 6
const radius = 50

export(int) var hitpoints = 150
var max_hitpoints = hitpoints
onready var sprite = $BossMove

var last_position

func _ready(): #make spawn bullet
	var step = 2 * PI / spawn_point_count
	
	last_position = global_position
	
	for i in range(spawn_point_count): 
		var spawn_point = Node2D.new()
		var pos = Vector2(radius,0).rotated(step * 1)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
		
	shoot_timer.wait_time = shooter_timer_wait_time
	shoot_timer.start()

func _process(delta: float): 
	if Global.boss_health <= 0: #if boss die
		get_tree().change_scene("res://Map/start/youwin!.tscn") #the finish scene appear
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)
	
	set_sprite_animation(last_position.direction_to(global_position))
	last_position = global_position
	
func set_sprite_animation(var movement_direction):
	if movement_direction == Vector2.ZERO:
		sprite.playing = false
		return
			
	# left animation
	if movement_direction.x < 0 and abs(movement_direction.x) > abs(movement_direction.y):
		sprite.animation = "move_left"
	# right animation
	elif movement_direction.x > 0 and abs(movement_direction.x) > abs(movement_direction.y):
		sprite.animation = "move_right"
#	#up animation
	elif movement_direction.y > 0 and abs(movement_direction.x) < abs(movement_direction.y):		
		sprite.animation = "move_down"
#	#down
	elif movement_direction.y < 0 and abs(movement_direction.x) < abs(movement_direction.y):		
		sprite.animation = "move_up"
		
	sprite.playing = true

	
func _on_ShootTimer_timeout(): 
	for s in rotater.get_children():
		var bullet = bullet_scene.instance()
		get_tree().root.add_child(bullet)
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation

func enemy_handle_hit():
	Global.boss_health-= Bullet.bullet_damage
	
	if Global.boss_health <= 0:
		queue_free()

func damage(damage_count): #if boss die, it disappear
	hitpoints -= damage_count
	if hitpoints <=0:
		queue_free()
#
#
