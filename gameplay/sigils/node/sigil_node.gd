class_name SigilNode
extends Node2D


var sigil : Sigil = null :
	set(value):
		sigil = value
		symbol.texture = sigil.symbol


@onready var symbol : Sprite2D = $Symbol
