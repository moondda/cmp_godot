extends Area2D

signal coin_collect

func _on_Area2D_body_entered(body): #get coin
	if body.is_in_group("player"):
		Global.coins +=1
		queue_free()
		

