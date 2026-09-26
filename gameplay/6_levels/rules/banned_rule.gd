class_name BannedRule
extends Rule


@export var banned_sigils : Array[Sigil] = []


func get_display() -> String:
	var display : String = "Can't use "
	for i : int in range(banned_sigils.size()):
		var sigil : Sigil = banned_sigils[i]
		display += sigil.name if sigil != null else "NULL "
		if i < banned_sigils.size() - 2:
			display += ", "
		elif (i == banned_sigils.size() - 2):
			if banned_sigils.size() == 2:
				display += " and "
			else:
				display += ", and "
	display += " sigils"
	return display


func is_satisfied(spells : Array[Spell]) -> bool:
	for spell : Spell in spells:
		if spell.sigil in banned_sigils:
			return false
	return true
