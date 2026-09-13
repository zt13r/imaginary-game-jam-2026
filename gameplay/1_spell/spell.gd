@tool
class_name Spell
extends Control


@export var frame : Frame = null :
	set(value):
		frame = value
		frame_sprite.texture = frame.texture
@export var sigil : Sigil = null :
	set(value):
		sigil = value
		sigil_sprite.texture = sigil.texture

@export_group("Modifiers")
@export var top_modifier : TopModifier = null :
	set(value):
		top_modifier = value
		top_modifier_sprite.texture = top_modifier.texture
@export var left_modifier : LeftModifier = null :
	set(value):
		left_modifier = value
		left_modifier_sprite.texture = left_modifier.texture
@export var right_modifier : RightModifier = null :
	set(value):
		right_modifier = value
		right_modifier_sprite.texture = right_modifier.texture
@export var bottom_modifier : BottomModifier = null :
	set(value):
		bottom_modifier = value
		bottom_modifier_sprite.texture = bottom_modifier.texture


@onready var frame_sprite : TextureRect = %FrameSprite
@onready var sigil_sprite : TextureRect = %SigilSprite
@onready var top_modifier_sprite : TextureRect = %TopModifierSprite
@onready var left_modifier_sprite : TextureRect = %LeftModifierSprite
@onready var right_modifier_sprite : TextureRect = %RightModifierSprite
@onready var bottom_modifier_sprite : TextureRect = %BottomModifierSprite
