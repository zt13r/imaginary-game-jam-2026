@tool
class_name Spell
extends Control


signal spell_selected(spell : Spell)


enum Target {
	SELF,
	OTHER
}


const TURN_COUNT_ONE_TEXTURE : Texture2D = preload("uid://do8d61ow3jgkm")
const TURN_COUNT_TWO_TEXTURE : Texture2D = preload("uid://dywnlikybtil2")
const TURN_COUNT_THREE_TEXTURE : Texture2D = preload("uid://ks3r2ajv4v8m")
const TURN_COUNT_FOUR_TEXTURE : Texture2D = preload("uid://dv0ooh16r3cbw")
const TURN_COUNT_FIVE_TEXTURE : Texture2D = preload("uid://dj2bb6mtjpdnd")

const NEGATION_LOGIC_TEXTURE : Texture2D = preload("uid://q1kkxqxgrwu0")
const INVERSION_LOGIC_TEXTURE : Texture2D = preload("uid://c7wthvg3kjxe")

const STRENGTH_ONE_TEXTURE : Texture2D = preload("uid://uuls3r3a2wyt")
const STRENGTH_TWO_TEXTURE : Texture2D = preload("uid://cr7yq6mjuauja")
const STRENGTH_THREE_TEXTURE : Texture2D = preload("uid://bta21pjpewbl8")

const TARGET_SELF_TEXTURE : Texture2D = preload("uid://dntcwmh02abrb")
const TARGET_OTHER_TEXTURE : Texture2D = preload("uid://dk8drv6sufrat")


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
@export var turn_count : int = 1 :
	set(value):
		turn_count = clampi(value, 1, 5)
		match turn_count:
			1 : turn_count_sprite.texture = TURN_COUNT_ONE_TEXTURE
			2 : turn_count_sprite.texture = TURN_COUNT_TWO_TEXTURE
			3 : turn_count_sprite.texture = TURN_COUNT_THREE_TEXTURE
			4 : turn_count_sprite.texture = TURN_COUNT_FOUR_TEXTURE
			5 : turn_count_sprite.texture = TURN_COUNT_FIVE_TEXTURE
			_ : push_error("Turn count is out of bounds.")
@export var strength : int = 1 :
	set(value):
		strength = clampi(value, 1, 3)
		match strength:
			1 : strength_sprite.texture = STRENGTH_ONE_TEXTURE
			2 : strength_sprite.texture = STRENGTH_TWO_TEXTURE
			3 : strength_sprite.texture = STRENGTH_THREE_TEXTURE
			_ : push_error("Strength value is out of bounds.")
@export var logic : LogicModifier = null :
	set(value):
		logic = value
		if logic is NegationLogic:
			logic_sprite.texture = NEGATION_LOGIC_TEXTURE
		elif logic is InversionLogic:
			logic_sprite.texture = INVERSION_LOGIC_TEXTURE
@export var target : Target = Target.OTHER :
	set(value):
		target = value
		match target:
			Target.SELF : target_sprite.texture = TARGET_SELF_TEXTURE
			Target.OTHER : target_sprite.texture = TARGET_OTHER_TEXTURE
			_ : push_error("Spell.Target value is out of bounds.")


@onready var frame_sprite : TextureRect = %FrameSprite
@onready var sigil_sprite : TextureRect = %SigilSprite
@onready var turn_count_sprite : TextureRect = %TurnCountSprite
@onready var logic_sprite : TextureRect = %LogicSprite
@onready var strength_sprite : TextureRect = %StrengthSprite
@onready var target_sprite : TextureRect = %TargetSprite


func _gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		spell_selected.emit(self)


func execute() -> void:
	pass
