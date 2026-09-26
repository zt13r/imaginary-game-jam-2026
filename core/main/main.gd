class_name MainGame
extends Node


const SIGIL_BUTTON_SCENE : PackedScene = preload("uid://do33dwe5lth1")
const EFFECT_BUTTON_SCENE : PackedScene = preload("uid://bch1wjqs2art5")

const SIGILS : Array[Sigil] = [
	preload("uid://dqct5kwpciyv8"), # aether
	preload("uid://dgmnu4kavulx2"), # earth
	preload("uid://0k4l5lbx5apa"), # fire
	preload("uid://c6inqib5eiwpl"), # miasma
	preload("uid://hjn3masc2j5q"), # water
	preload("uid://cf8vdy41wb0lk"), # wind
]

const REACTION_MAXIMUM_SIZE : Vector2 = Vector2(28, 28)


@export var cast_button : Button = null
@export var bg_color : Color = Color(0.172, 0.172, 0.172, 1.0)
@export var cast_bg_color : Color = Color(0.056, 0.056, 0.056, 1.0)


static var seconds_turn_increment : float = 1.0


@onready var background : ColorRect = %Background
@onready var overlay : ColorRect = %Overlay

@onready var puzzle : Puzzle = %Puzzle
@onready var target : Target = %Target
@onready var magic_glyph : MagicGlyph = %MagicGlyph

@onready var sigil_container : GridContainer = %SigilContainer
@onready var sigil_texture : TextureRect = %SigilTexture
@onready var sigil_name : Label = %SigilName
@onready var sigil_effect_button : EffectButton = %SigilEffectButton

@onready var effect_container : GridContainer = %EffectContainer
@onready var effect_name : Label = %EffectName
@onready var library_effect_texture : TextureRect = %LibraryEffectTexture
@onready var effects_library : VBoxContainer = %Effects

@onready var reactions_container : GridContainer = %ReactionsContainer
@onready var spell_editor : PanelContainer = %SpellEditor
@onready var rulebook : PanelContainer = %Rulebook

@onready var turn_count_menu : OptionButton = %TurnCountMenu
@onready var grid_container : GridContainer = %GridContainer
@onready var result_screen: PanelContainer = %ResultScreen

@onready var retry_button : Button = %RetryButton
@onready var next_level_button : Button = %NextLevelButton
@onready var year_test : Label = %YearTest


func _ready() -> void:
	_populate_sigil_editor()
	_populate_library()

	Game.target = target

	overlay.hide()
	result_screen.hide()
	spell_editor.show()
	rulebook.show()


func _populate_sigil_editor() -> void:
	for sigil : Sigil in SIGILS:
		var button : SigilButton = SIGIL_BUTTON_SCENE.instantiate()
		button.sigil = sigil
		sigil_container.add_child(button)

		if magic_glyph != null:
			button.pressed.connect(
				magic_glyph._on_sigil_selected.bind(button.sigil))

		button.pressed.connect(
			_update_sigil_info.bind(button.sigil))

	sigil_effect_button.pressed.connect(
		_update_effect_info.bind(sigil_effect_button.effect)
	)

	if magic_glyph != null:
		magic_glyph.spell_selected.connect(_update_spell_info)

	# Turn count
	for i in range(3):
		turn_count_menu.add_item(str(i + 1))


func _populate_library() -> void:
	if Database.library.is_empty():
		push_error("Library is empty.")
		return

	for effect : Effect in Database.library:
		var button : EffectButton = EFFECT_BUTTON_SCENE.instantiate()
		button.effect = effect
		effect_container.add_child(button)

		button.pressed.connect(
			_update_effect_info.bind(button.effect)
		)


func _update_spell_info(spell : Spell) -> void:
	_update_sigil_info(spell.sigil)
	turn_count_menu.selected = spell.turn_count - 1


func _update_sigil_info(sigil : Sigil) -> void:
	sigil_texture.texture = sigil.texture
	sigil_name.text = sigil.name
	sigil_effect_button.effect = sigil.base_effect


func _update_effect_info(effect : Effect) -> void:
	if effect == null:
		return
	effect_name.text = effect.name
	library_effect_texture.texture = effect.icon

	for child : Control in reactions_container.get_children():
		child.queue_free()

	var reaction_pairs : Array = Database.library[effect]

	for pair : Reaction in reaction_pairs:

		var h_box : HBoxContainer = HBoxContainer.new()
		h_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h_box.size_flags_vertical = Control.SIZE_EXPAND_FILL

		var button_1 : EffectButton =\
			EFFECT_BUTTON_SCENE.instantiate()
		button_1.custom_maximum_size = REACTION_MAXIMUM_SIZE
		button_1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button_1.size_flags_vertical = Control.SIZE_EXPAND_FILL
		button_1.effect = pair.effect_a

		var label : Label = Label.new()
		label.add_theme_font_size_override("font_size", 28)
		label.self_modulate = Color.BLACK
		label.text = "+"

		var button_2 : EffectButton =\
			EFFECT_BUTTON_SCENE.instantiate()
		button_2.custom_maximum_size = REACTION_MAXIMUM_SIZE
		button_2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button_2.size_flags_vertical = Control.SIZE_EXPAND_FILL
		button_2.effect = pair.effect_b

		button_1.pressed.connect(
			_update_effect_info.bind(button_1.effect)
		)
		button_2.pressed.connect(
			_update_effect_info.bind(button_2.effect)
		)

		h_box.add_child(button_1)
		h_box.add_child(label)
		h_box.add_child(button_2)

		reactions_container.add_child(h_box)

	effects_library.show()


func cast() -> void:
	year_test.hide()
	overlay.show()
	background.color = cast_bg_color

	rulebook.hide()
	spell_editor.hide()
	result_screen.hide()

	await get_tree().create_timer(1.0).timeout

	target.show()
	overlay.hide()
	year_test.show()


func done_cast() -> void:
	target.hide()
	background.color = bg_color
	result_screen.hide()
	rulebook.show()


func _on_retry_button_pressed() -> void:
	result_screen.hide()
	spell_editor.show()
	cast_button.disabled = false


func _on_next_level_button_pressed() -> void:
	overlay.show()
	puzzle.next_level()
	match (puzzle.level_index + 1):
		1: year_test.text = "Year 1 Midterms"
		2: year_test.text = "Year 1 Finals"
		3: year_test.text = "Year 2 Midterms"
		4: year_test.text = "Year 2 Finals"
		5: year_test.text = "Year 3 Midterms"
		6: year_test.text = "Year 3 Finals"
		7: year_test.text = "Year 4 Midterms"
		8: year_test.text = "Year 4 Finals"
		9: year_test.text = "Graduation Exam"
		_: print("Actual level: ", puzzle.current_level)

	result_screen.hide()
	spell_editor.show()
	cast_button.disabled = false

	await get_tree().create_timer(1.0).timeout

	overlay.hide()
