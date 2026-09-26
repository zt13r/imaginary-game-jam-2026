class_name OnlyRule
extends Rule


func get_display() -> String:
	var display : String =\
		"The last statuses must only be the target statuses"
	return display


func is_satisfied(target : Target, goal : Array[Effect]) -> bool:
	var target_current_effects : Dictionary[Effect, int] =\
		target.effects
	for effect : Effect in target_current_effects:
		if effect not in goal:
			return false
	return true
