extends TextureRect


func _ready(): #set hp_bar
	$Health_bar.max_value = 150
	$Health_bar.value = 150
func HP_bar_change(value): #change hp_bar
	$Health_bar.value = value
func MAX_HP_bar_change(value): #change max_hp_bar
	$Health_bar.max_value = value
func set_max_HP(value): #change max_hp_bar
	$Health_bar.max_value = value
