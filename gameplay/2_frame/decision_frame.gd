class_name DecisionFrame
extends Frame


var texture : Texture2D = preload("uid://dsif5pw0120s1")


func process(
	spell : Spell,
	sigil : Sigil,
	turn_count : int,
	logic : LogicModifier,
	strength : int,
	spell_target : Spell.Target
) -> void:

	var effect : String = sigil.effect if logic is not InversionLogic else sigil.inverse_effect
	var target : Target = null
	if spell_target == Spell.Target.SELF:
		target = Game.target_self
	elif spell_target == Spell.Target.OTHER:
		target = Game.target_other

	if not target.has_meta
