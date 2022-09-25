extends TextureRect
 

#same HP_bar's function
func _ready():
	$Health_bar.max_value = 150
	$Health_bar.value = 150
func HP_bar_change(value):
	$Health_bar.value = value
func MAX_HP_bar_change(value):
	$Health_bar.max_value = value
func set_max_HP(value):
	$Health_bar.max_value = value
