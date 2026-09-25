class_name Spell
extends Control


signal spell_selected(spell : Spell)


const TURN_COUNT_ONE_TEXTURE : Texture2D = preload("uid://do8d61ow3jgkm")
const TURN_COUNT_TWO_TEXTURE : Texture2D = preload("uid://dywnlikybtil2")
const TURN_COUNT_THREE_TEXTURE : Texture2D = preload("uid://ks3r2ajv4v8m")


@export var frame : Frame = null :
	set(value):
		frame = value
		if frame == null:
			frame_sprite.hide()
		else:
			var random_index : int = randi_range(0, frame.textures.size() - 1)
			frame_sprite.texture = frame.textures[random_index]
			frame_background_sprite.texture = frame.backgrounds[random_index]
	get:
		if frame == null:
			frame = preload("uid://bsh5gkkxtblsi")
		return frame
@export var sigil : Sigil = null :
	set(value):
		sigil = value
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

@export_group("Modifiers")
@export var turn_count : int = -1 :
	set(value):
		turn_count = min(value, 3)
		match turn_count:
			1 : turn_count_sprite.texture = TURN_COUNT_ONE_TEXTURE
			2 : turn_count_sprite.texture = TURN_COUNT_TWO_TEXTURE
			3 : turn_count_sprite.texture = TURN_COUNT_THREE_TEXTURE
			_ : push_error("Turn count is out of bounds.")


var previous_spell : Spell = null
var next_spell : Spell = null


@onready var frame_background_sprite : TextureRect = %FrameBackground
@onready var frame_sprite : TextureRect = %FrameSprite

@onready var sigil_sprite : TextureRect = %SigilSprite

@onready var turn_count_sprite : TextureRect = %TurnCountSprite


func _ready() -> void:
	name = "Spell"
	turn_count = 3


func _gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		spell_selected.emit(self)


func cast() -> void:
	if then_spell == null:
		push_error(name + " ThenSpell is null.")
		return
	if sigil == null:
		return

	var effect : Effect = sigil.base_effect

	if not Game.target.has_effect(effect):
		Game.target.add_effect(effect, turn_count)

	next_spell = then_spell



func get_previous_spell_then_spell(existing_spells : Array[Spell]) -> void:
	if previous_spell == null:
		var previous_index : int =\
			posmod(existing_spells.find(self) - 1, existing_spells.size())
		previous_spell = existing_spells[previous_index]

	previous_spell.then_spell = self

	#print("%s : %s (should be %s) " % [
		#previous_spell.name,
		#previous_spell.then_spell.name,
		#name
	#])
