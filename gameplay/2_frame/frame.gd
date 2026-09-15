@abstract
class_name Frame
extends Resource


@abstract func process(
	sigil : Sigil,
	turn_count : int,
	logic : LogicModifier,
	severity : int,
	target : Spell.Target
) -> void
