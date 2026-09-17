class_name RingFrame
extends Frame


var texture : Texture2D = preload("uid://bl8usikvqxi66")


func process(
	spell : Spell,
	sigil : Sigil,
	turn_count : int,
	logic : LogicModifier,
	strength : int,
	spell_target : Spell.SpellTarget
) -> void:

	var effect : String = sigil.effect if logic is not InversionLogic else sigil.inverse_effect
	var target : Target = null
	if spell_target == Spell.SpellTarget.SELF:
		target = Game.target_self
	elif spell_target == Spell.SpellTarget.OTHER:
		target = Game.target_other

	if not target.has_meta(effect):
		if not logic is NegationLogic:
			target.set_meta(effect, {
				"turn_count" : turn_count,
				"strength" : strength
				}
			)
		else:
			target.remove_meta(effect)

	spell.next_spell = spell.then_spell
