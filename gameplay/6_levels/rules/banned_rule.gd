class_name BannedRule
extends Rule


@export var banned_sigils : Array[Sigil] = []


func get_display() -> String:
	var display : String = "Can't use "
	for i : int in range(banned_sigils.size()):
		var sigil : Sigil = banned_sigils[i]
		display += sigil.name
		if i < banned_sigils.size():
			display += ", "
		elif (i == banned_sigils.size() - 2):
			display += "and "
	if banned_sigils.size() == 1:
		display += " Sigils."
	return display


func is_satisfied(spells : Array[Spell]) -> bool:
	for spell : Spell in spells:
		if spell.sigil in banned_sigils:
			return false
	return true
