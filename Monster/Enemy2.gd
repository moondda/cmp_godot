extends KinematicBody2D

export(int) var hitpoints =100
var max_hitpoints = hitpoints

onready var BULLET_SCENE = preload("res://Monster/M_Bullet.tscn")

var player = null
var move = Vector2.ZERO
var speed = 100
var health = 150

var velocity = Vector2.ZERO
var path = []
var threshold = 16
var nav = null

onready var sprite = $move2

func _ready():  #relate with another scripts
	#yield(owner, "ready")
	nav = $"../../Navigation2D"
	player = $"../../Player"


func _physics_process(delta):
	move = Vector2.ZERO
	
	
	# get the current path from enemy to the player's position
	if player != null: 
		get_target_path(player.global_position)
	
	if path.size()> 0:
		var distance = speed*delta
		move_to_target(distance)
		

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



func move_to_target(distance):
	
	# last point is used for linear interpolation
	var last_point : = position
	
	# loop through all the points of the path
	for index in range(path.size()):
		var distance_to_next = last_point.distance_to(path[0])
		$"../../Line2D".points = path
		if distance <= distance_to_next and distance >= 0.0:
						
			var new_pos = last_point.linear_interpolate(path[0], distance / distance_to_next)
			# change the sprite animation by using the direction from the enemy's
			# current position and the new position. 
			set_sprite_animation(position.direction_to(new_pos))
			
			position = new_pos
			break
		
		
		elif path.size() == 1 and distance >= distance_to_next:
			var new_pos = path[0]
			
			# change the sprite animation by using the direction from the enemy's
			# current position and the new position. 
			set_sprite_animation(position.direction_to(new_pos))
			
			position = new_pos
			break
		
		distance -= distance_to_next
		last_point = path[0]
		path.remove(0)


func get_target_path(target_pos):
	path = nav.get_simple_path(global_position, target_pos, false)

func _on_Area2D_body_entered(body): 
	if body != self:
		player = body

func _on_Area2D_body_exited(body):
	player = null
	
func fire():  #ineraction with player's bullet
	var bullet = BULLET_SCENE.instance()
	bullet.position = get_global_position()
	bullet.player = player
	get_parent().add_child(bullet)
	$Timer.set_wait_time(1)

func _on_Timer_timeout():
	if player != null:
		fire()
	
func enemy_handle_hit(): #hp bar option
	health -= Bullet.bullet_damage
	$HPBar.set_percent_value_int(health)
	
	if health <= 0: #if enemy die, it left coin and disappear
		var coin = preload("res://Player1/coin.tscn")
		var new_coin = coin.instance()
		get_node("/root").add_child(new_coin)   
		new_coin.global_position = global_position
		queue_free()
