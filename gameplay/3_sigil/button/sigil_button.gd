class_name SigilButton
extends TextureButton


var sigil : Sigil = null


@onready var icon : TextureRect = %Icon


func _ready() -> void:
	icon.texture = sigil.texture
