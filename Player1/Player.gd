extends KinematicBody2D

var bullet_speed = 500
var bullet = preload("res://Player1/bullet.tscn")
var onshot = true
var bullet_term = 0.2
var level = 0
var speed = 200
var health =150

func _ready(): #set player state
	$HP_bar.set_max_HP(Global.max_health)
	$HP_bar.HP_bar_change(Global.health)
	$skill.skill_cool_change(Global.skill_cool)
	
	$case2.region_enabled = true
	
	if Global.skill_cool < 40 :
		skill_replenish()

func skill_replenish(): #check skill_cool and weapon state
	if Global.weapon == false:
		Global.weapon = true
	for skill_cool in 40-Global.skill_cool:
		yield(get_tree().create_timer(1),"timeout")
		Global.skill_cool +=1
		$skill.skill_cool_change(Global.skill_cool)
		print(Global.skill_cool)
	Global.skill = true
	
func anim(): #player animation
	if Global.health > 0:
		if Input.is_action_pressed("right"):
			$AnimatedSprite.play("walk")
			$AnimatedSprite.flip_h = true
			$case.flip_h = true
		elif Input.is_action_pressed("left"):
			$AnimatedSprite.play("walk")
			$AnimatedSprite.flip_h = false
			$case.flip_h = false
		elif Input.is_action_pressed("up"):	
			$AnimatedSprite.play("walk")
		elif Input.is_action_pressed("down"):		
			$AnimatedSprite.play("walk")
		else:
			$AnimatedSprite.play("idle")
			$sound/move.stop()
	
	elif Global.health <= 0:
		$AnimatedSprite.play("dead")
		$sound/move.stop()
		$sound/dead.play()
		
func sound(): #sound
	if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left") or Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
		$sound/move.play()
	

func get_move(): #player movement
	var direction: = Vector2.ZERO
	if Global.health > 0:
		direction = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")).normalized()			
		var velocity = direction * speed
		move_and_slide(velocity, Vector2.UP)
	
func upgrade(): #player level up
	if Global.health > 0:
		if Global.coins > 0:
			if Input.is_action_just_pressed("upgrade1") and bullet_term > 0.05: #bullet rate
				Global.coins -= 1
				Global.bullet_term -= 0.01
				Global.level += 1
			if Input.is_action_just_pressed("upgrade2"): #bullet damage up
				Global.coins -= 1
				Bullet.bullet_damage += 1
				Global.level += 1
			if Input.is_action_just_pressed("upgrade3"): #health up
				Global.coins -= 1
				Global.health += 10
				Global.max_health += 10
				Global.level += 1
				$HP_bar.MAX_HP_bar_change(Global.max_health)
				$HP_bar.HP_bar_change(Global.health)
				
		if Global.skill and Input.is_action_just_pressed("skill"): #player's skill state
				Global.skill = false
				Global.weapon = !Global.weapon 
				Global.skill_cool = 0
				$case2.region_enabled = false
				$case.region_enabled = true
				$skill.skill_cool_change(Global.skill_cool)
				speed += 100
				Global.bullet_term -= 0.05
				Bullet.bullet_damage += 3
				yield(get_tree().create_timer(5),"timeout")
				speed -= 100
				Global.bullet_term += 0.05
				Bullet.bullet_damage -= 3
				Global.weapon = !Global.weapon
				$case2.region_enabled = true
				$case.region_enabled = false
				for skill_cool in 40:
					yield(get_tree().create_timer(1),"timeout")
					Global.skill_cool +=1
					$skill.skill_cool_change(Global.skill_cool)
				Global.skill = true
				
func _physics_process(delta): 
	get_move()	
	upgrade()
	anim()
	sound()
	$HP_bar.HP_bar_change(Global.health)
	$skill.skill_cool_change(Global.skill_cool)
	if Global.health <= 0:
		get_tree().change_scene("res://GameOver.tscn")
	
func _on_Area2D_area_entered(area): #check key and coin
	if area.is_in_group("key1"):
		NewScript.key_picked_up1 = true
		area.get_parent().queue_free()
		
	if area.is_in_group("key2"):
		NewScript.key_picked_up2 = true
		area.get_parent().queue_free()
		
	if area.is_in_group("key3"):
		NewScript.key_picked_up3 = true
		area.get_parent().queue_free()
	
	if area.is_in_group("key4"):
		NewScript.key_picked_up_mini = true
		area.get_parent().queue_free()
		
	if area.is_in_group("minikey"):
		NewScript.key_picked_up_mini2 = true
		area.get_parent().queue_free()
		
	if area.is_in_group("Coin"):
		$coin.play()
		

func _on_Area2D_body_entered(body): #check player hit
	
	if body.is_in_group("Monster"):
		$sound/hit.play()
		Global.health -= 10
		$HP_bar.HP_bar_change(Global.health)
		yield(get_tree().create_timer(0.5),"timeout")


