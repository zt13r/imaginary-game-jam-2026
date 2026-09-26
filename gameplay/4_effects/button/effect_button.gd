class_name EffectButton
extends TextureButton


const GODOT_ICON = preload("uid://bo14rh1iyyycl")


var effect : Effect = null


func _ready() -> void:
	if effect != null:
		if effect.icon != null:
			texture_normal = effect.icon
		else:
			texture_normal = GODOT_ICON
