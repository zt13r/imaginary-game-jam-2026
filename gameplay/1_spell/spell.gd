@tool
class_name Spell
extends Control


signal spell_selected(spell : Spell)


@export var frame : Frame = null :
	set(value):
		frame = value
		if frame == null:
			if is_node_ready():
				frame_sprite.hide()
		else:
			frame_sprite.texture = frame.texture
@export var sigil : Sigil = null :
	set(value):
		sigil = value
		if sigil == null:
			if is_node_ready():
				sigil_sprite.hide()
		else:
			sigil_sprite.texture = sigil.texture

@export var then_spell : Spell = null
@export var else_spell : Spell = null

@export_group("Modifiers")
@export var top_modifier : TopModifier = null :
	set(value):
		top_modifier = value
		if top_modifier == null:
			if is_node_ready():
				top_modifier_sprite.hide()
		else:
			top_modifier_sprite.texture = top_modifier.texture
@export var left_modifier : LeftModifier = null :
	set(value):
		left_modifier = value
		if left_modifier == null:
			if is_node_ready():
				left_modifier_sprite.hide()
		else:
			left_modifier_sprite.texture = left_modifier.texture
@export var right_modifier : RightModifier = null :
	set(value):
		right_modifier = value
		if right_modifier == null:
			if is_node_ready():
				right_modifier_sprite.hide()
		else:
			right_modifier_sprite.texture = right_modifier.texture
@export var bottom_modifier : BottomModifier = null :
	set(value):
		bottom_modifier = value
		if bottom_modifier == null:
			if is_node_ready():
				bottom_modifier_sprite.hide()
		else:
			bottom_modifier_sprite.texture = bottom_modifier.texture


@onready var frame_sprite : TextureRect = %FrameSprite
@onready var sigil_sprite : TextureRect = %SigilSprite
@onready var top_modifier_sprite : TextureRect = %TopModifierSprite
@onready var left_modifier_sprite : TextureRect = %LeftModifierSprite
@onready var right_modifier_sprite : TextureRect = %RightModifierSprite
@onready var bottom_modifier_sprite : TextureRect = %BottomModifierSprite


func _gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		spell_selected.emit(self)


func execute() -> void:
	pass
