@abstract
class_name Frame
extends Resource


@abstract func process(
	spell : Spell,
	sigil : Sigil,
	turn_count : int,
	logic : LogicModifier,
	strength : int,
	spell_target : Spell.SpellTarget
) -> void
