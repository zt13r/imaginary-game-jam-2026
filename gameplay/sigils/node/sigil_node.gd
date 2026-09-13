@tool
class_name SigilNode
extends Control


@export var sigil : Sigil = null :
	set(value):
		sigil = value
		symbol.texture = sigil.symbol if sigil != null else null

		if sigil is CheckSigil:
			sigil.


@onready var symbol : TextureRect = $Symbol
