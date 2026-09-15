@tool
class_name Spell
extends Control


signal spell_selected(spell : Spell)


enum Target {
	SELF,
	OTHER
}


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
@export var turn_modifier : TurnModifier = null :
	set(value):
		turn_modifier = value
		if turn_modifier == null:
			if is_node_ready():
				turn_modifier_sprite.hide()
		else:
			turn_modifier_sprite.texture = turn_modifier.texture
@export var logic_modifier : LogicModifier = null :
	set(value):
		logic_modifier = value
		if logic_modifier == null:
			if is_node_ready():
				logic_modifier_sprite.hide()
		else:
			logic_modifier_sprite.texture = logic_modifier.texture
@export var severity_modifier : SeverityModifier = null :
	set(value):
		severity_modifier = value
		if severity_modifier == null:
			if is_node_ready():
				severity_modifier_sprite.hide()
		else:
			severity_modifier_sprite.texture = severity_modifier.texture
@export var direction_modifier : DirectionModifier = null :
	set(value):
		direction_modifier = value
		if direction_modifier == null:
			if is_node_ready():
				direction_modifier_sprite.hide()
		else:
			direction_modifier_sprite.texture = direction_modifier.texture


@onready var frame_sprite : TextureRect = %FrameSprite
@onready var sigil_sprite : TextureRect = %SigilSprite
@onready var turn_modifier_sprite : TextureRect = %TurnModifierSprite
@onready var logic_modifier_sprite : TextureRect = %LogicModifierSprite
@onready var severity_modifier_sprite : TextureRect = %SeverityModifierSprite
@onready var direction_modifier_sprite : TextureRect = %DirectionModifierSprite


func _gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		spell_selected.emit(self)


func execute() -> void:
	pass
