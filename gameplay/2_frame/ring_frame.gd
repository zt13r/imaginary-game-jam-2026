class_name RingFrame
extends Frame


var texture : Texture2D = preload("uid://bl8usikvqxi66")


func process(
	sigil : Sigil,
	turn_count : int,
	logic : LogicModifier,
	severity : int,
	target : Spell.Target
) -> void:

	var effect : String = sigil.effect
