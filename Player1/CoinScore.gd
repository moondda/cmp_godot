extends Label

func _process(delta): #display coin
	text = "Coins: "+String(Global.coins)
