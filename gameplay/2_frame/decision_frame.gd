class_name DecisionFrame
extends Frame


var texture : Texture2D = preload("uid://dsif5pw0120s1")


func process(
	spell : Spell,
	sigil : Sigil,
	turn_count : int,
	logic : LogicModifier,
	strength : int,
	spell_target : Spell.SpellTarget
) -> void:

	var effect : String = sigil.effect if logic is not InversionLogic else sigil.inverse_effect
	var target : Array[Target] = []
	if spell_target == Spell.SpellTarget.SELF:
		target = [Game.target_self]
	elif spell_target == Spell.SpellTarget.OTHER:
		target = [Game.target_other]
	elif spell_target == Spell.SpellTarget.BOTH:
		target = [Game.target_self, Game.target_other]

	var so_true : bool = false

	if logic is NegationLogic:
		for t in target:
			if not t.has_meta(effect):
				so_true = true
			else:
				so_true = false
	else:
		for t in target:
			if t.has_meta(effect):
				so_true = true
			else:
				so_true = false

	if so_true:
		spell.next_spell = spell.then_spell
	else:
		spell.next_spell = spell.else_spell
