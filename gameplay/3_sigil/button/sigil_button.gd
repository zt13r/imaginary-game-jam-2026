class_name SigilButton
extends TextureButton


var sigil : Sigil = null


func _ready() -> void:
	texture_normal = sigil.texture
