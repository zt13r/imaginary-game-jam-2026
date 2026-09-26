class_name EffectButton
extends TextureButton


const GODOT_ICON = preload("uid://bo14rh1iyyycl")


var effect : Effect = null :
	set(value):
		effect = value
		change_texture()


func _ready() -> void:
	change_texture()


func change_texture() -> void:
	if effect != null:
		if effect.icon != null:
			texture_normal = effect.icon
		else:
			texture_normal = GODOT_ICON
