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

const TARGET_SELF_TEXTURE : Texture2D = preload("uid://dntcwmh02abrb")
const TARGET_OTHER_TEXTURE : Texture2D = preload("uid://dk8drv6sufrat")
const TARGET_BOTH_TEXTURE : Texture2D = preload("uid://bq0bm3wlquege")


@export var frame : Frame = null :
	set(value):
		frame = value
		await ready
		if frame == null:
			frame_sprite.hide()
		else:
			frame_sprite.texture = frame.texture
			frame_background_sprite.texture = frame.background
	get:
		if frame == null:
			frame = preload("uid://bsh5gkkxtblsi")
		return frame
@export var sigil : Sigil = null :
	set(value):
		sigil = value
		await ready
		if sigil == null:
			sigil_sprite.hide()
		else:
			sigil_sprite.texture = sigil.texture

@export var then_spell : Spell = null :
	set(value):
		then_spell = value
		if frame != null and frame.type == Frame.Type.EXECUTION:
			next_spell = then_spell
		if not Engine.is_editor_hint():
			queue_redraw()
@export var else_spell : Spell = null :
	set(value):
		else_spell = value
		if not Engine.is_editor_hint():
			queue_redraw()

@export_group("Modifiers")
@export var turn_count : int = 1 :
	set(value):
		turn_count = clampi(value, 1, 5)
		await ready
		match turn_count:
			1 : turn_count_sprite.texture = TURN_COUNT_ONE_TEXTURE
			2 : turn_count_sprite.texture = TURN_COUNT_TWO_TEXTURE
			3 : turn_count_sprite.texture = TURN_COUNT_THREE_TEXTURE
			_ : push_error("Turn count is out of bounds.")
@export var spell_target : SpellTarget = SpellTarget.OTHER :
	set(value):
		spell_target = value
		await ready
		match spell_target:
			SpellTarget.SELF : target_sprite.texture = TARGET_SELF_TEXTURE
			SpellTarget.OTHER : target_sprite.texture = TARGET_OTHER_TEXTURE
			SpellTarget.BOTH : target_sprite.texture = TARGET_BOTH_TEXTURE
			_ : push_error("SpellTarget value is out of bounds.")


var previous_spell : Spell = null
var next_spell : Spell = null


@onready var frame_background_sprite : TextureRect = %FrameBackground
@onready var frame_sprite : TextureRect = %FrameSprite

@onready var sigil_sprite : TextureRect = %SigilSprite

@onready var turn_count_sprite : TextureRect = %TurnCountSprite
@onready var target_sprite : TextureRect = %TargetSprite


func _ready() -> void:
	name = "Spell"


func _gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		spell_selected.emit(self)


func _draw() -> void:
	if then_spell == null:
		push_error(name + " ThenSpell is null.")
		return
	if frame == null:
		push_error(name + " Frame is null.")
		return

	var spell_pos : Vector2 = global_position
	var then_spell_pos : Vector2 = then_spell.global_position

	#print("%s: (%d, %d)" % [then_spell.name, then_spell_pos.x, then_spell_pos.y])

	if frame.type == Frame.Type.EXECUTION:
		draw_line(
			spell_pos, then_spell_pos, Color.WHITE, 4.0
		)

	elif frame.type == Frame.Type.DECISION:
		if else_spell == null:
			push_error(name + " ElseSpell is null.")
			return
		var else_spell_pos : Vector2 = else_spell.global_position

		draw_line(
			spell_pos, then_spell_pos, Color.WHITE, 4.0
		)

		draw_line(
			spell_pos, else_spell_pos, Color.WHITE, 4.0
		)


func cast() -> void:
	if frame.type == Frame.Type.EXECUTION:
		_execute_spell()
	elif frame.type == Frame.Type.DECISION:
		_decide_spell()


func get_previous_spell_then_spell(existing_spells : Array[Spell]) -> void:
	if previous_spell == null:
		var previous_index : int =\
			posmod(existing_spells.find(self) - 1, existing_spells.size())
		previous_spell = existing_spells[previous_index]
	previous_spell.then_spell = self
	print(self, ": ", previous_spell)


func _execute_spell() -> void:
	if then_spell == null:
		push_error(name + " ThenSpell is null.")
		return

	var effect : String = sigil.effect

	var target : Array[Target] = []
	if spell_target == SpellTarget.SELF:
		target = [Game.target_self]
	elif spell_target == SpellTarget.OTHER:
		target = [Game.target_other]
	elif spell_target == SpellTarget.BOTH:
		target = [Game.target_self, Game.target_other]

	for t in target:
		if not t.has_meta(effect):
			t.set_meta(effect, turn_count)

	next_spell = then_spell


func _decide_spell() -> void:
	if then_spell == null:
		push_error(name + " ThenSpell is null.")
		return
	if else_spell == null:
		push_error(name + " ElseSpell is null.")
		return

	var effect : String = sigil.effect

	var target : Array[Target] = []
	if spell_target == Spell.SpellTarget.SELF:
		target = [Game.target_self]
	elif spell_target == Spell.SpellTarget.OTHER:
		target = [Game.target_other]
	elif spell_target == Spell.SpellTarget.BOTH:
		target = [Game.target_self, Game.target_other]

	var conditions_satisfied : bool = false

	for t in target:
		if t.has_meta(effect):
			conditions_satisfied = true
			continue
		conditions_satisfied = false

	if conditions_satisfied:
		next_spell = then_spell
	else:
		next_spell = else_spell
