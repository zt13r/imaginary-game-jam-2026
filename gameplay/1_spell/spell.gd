@tool
class_name Spell
extends Control


signal spell_selected(spell : Spell)


enum SpellTarget {
	SELF,
	OTHER,
	BOTH
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
const TARGET_BOTH_TEXTURE : Texture2D = preload("uid://bq0bm3wlquege")


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
		if frame is DecisionFrame and not turn_comparison_sprite.visible:
			turn_comparison_sprite.texture = turn_comparison.texture
			turn_comparison_sprite.show()
		elif not frame is DecisionFrame and turn_comparison_sprite.visible:
			turn_comparison_sprite.hide()
@export var turn_comparison : ComparisonModifier = null
@export var logic : LogicModifier = null :
	set(value):
		logic = value
		if logic is NegationLogic:
			logic_sprite.texture = NEGATION_LOGIC_TEXTURE
		elif logic is InversionLogic:
			logic_sprite.texture = INVERSION_LOGIC_TEXTURE
@export var strength : int = 1 :
	set(value):
		strength = clampi(value, 1, 3)
		match strength:
			1 : strength_sprite.texture = STRENGTH_ONE_TEXTURE
			2 : strength_sprite.texture = STRENGTH_TWO_TEXTURE
			3 : strength_sprite.texture = STRENGTH_THREE_TEXTURE
			_ : push_error("Strength value is out of bounds.")
@export var spell_target : SpellTarget = SpellTarget.OTHER :
	set(value):
		spell_target = value
		match spell_target:
			SpellTarget.SELF : target_sprite.texture = TARGET_SELF_TEXTURE
			SpellTarget.OTHER : target_sprite.texture = TARGET_OTHER_TEXTURE
			SpellTarget.BOTH : target_sprite.texture = TARGET_BOTH_TEXTURE
			_ : push_error("SpellTarget value is out of bounds.")


var next_spell : Spell = null
var is_dragging : bool = false


@onready var frame_sprite : TextureRect = %FrameSprite
@onready var sigil_sprite : TextureRect = %SigilSprite

@onready var turn_count_sprite : TextureRect = %TurnCountSprite
@onready var logic_sprite : TextureRect = %LogicSprite
@onready var strength_sprite : TextureRect = %StrengthSprite
@onready var target_sprite : TextureRect = %TargetSprite

@onready var turn_comparison_sprite : TextureRect = %TurnComparisonSprite


func _gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		spell_selected.emit(self)


func execute() -> void:
	if frame is RingFrame:
		_process_ring()
	elif frame is DecisionFrame:
		_process_decision()


func _process_ring() -> void:
	var effect : String = sigil.effect if logic is not InversionLogic else sigil.inverse_effect
	var target : Target = null
	if spell_target == SpellTarget.SELF:
		target = Game.target_self
	elif spell_target == SpellTarget.OTHER:
		target = Game.target_other

	if not target.has_meta(effect):
		if not logic is NegationLogic:
			target.set_meta(effect, {
				"turn_count" : turn_count,
				"strength" : strength
				}
			)
		else:
			target.remove_meta(effect)

	next_spell = then_spell


func _process_decision() -> void:
	var effect : String = sigil.effect if logic is not InversionLogic else sigil.inverse_effect
	var target : Array[Target] = []
	if spell_target == Spell.SpellTarget.SELF:
		target = [Game.target_self]
	elif spell_target == Spell.SpellTarget.OTHER:
		target = [Game.target_other]
	elif spell_target == Spell.SpellTarget.BOTH:
		target = [Game.target_self, Game.target_other]

	var so_true : bool = false

	if logic is NegationLogic:
		for t in target:
			if not t.has_meta(effect):
				so_true = true
			else:
				so_true = false
	else:
		for t in target:
			if t.has_meta(effect):
				so_true = true
			else:
				so_true = false

	if so_true:
		next_spell = then_spell
	else:
		next_spell = else_spell
