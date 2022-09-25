extends TextureRect


func _ready(): #set skill bar value
	$Skill_bar.value = 40
	
func skill_cool_change(value): #change_skill_cool
	$Skill_bar.value = value
