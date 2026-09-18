class_name Target
extends Control


#                    effect_name, turn_count
var effects : Dictionary[String, int] = {}


func _ready() -> void:
	if mouse_filter != MOUSE_FILTER_IGNORE:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	


func has_effect(effect : String) -> bool:
	if effect in effects:
		return true
	return false


func add_effect(effect : String, turn_count : int) -> void:
	effects[effect] = turn_count
	print(name, " effects: ", effects)


func increment_turn() -> void:
	for e in effects.keys():
		effects[e] = effects[e] - 1
		if effects[e] <= 0:
			effects.erase(e)
			print("%s %s effect gone bro" % [
				name, e
			])
