extends Label

func _process(delta): #display player level
	text = "LV: " + String(Global.level)
