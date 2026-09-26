class_name SpellCountRule
extends Rule


@export var minimum : int = 2
@export var maximum : int = 8


func get_display() -> String:
	var display : String = "Maximum of %d spells" % maximum
	return display


func is_satisfied(spell_count : int) -> bool:
	return minimum <= spell_count and spell_count <= maximum
