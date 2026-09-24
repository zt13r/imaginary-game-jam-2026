class_name MainGame
extends Node


const SIGIL_BUTTON_SCENE : PackedScene = preload("uid://do33dwe5lth1")

const SIGILS : Array[Sigil] = [
	preload("uid://dqct5kwpciyv8"), # aether
	preload("uid://dgmnu4kavulx2"), # earth
	preload("uid://0k4l5lbx5apa"), # fire
	preload("uid://c6inqib5eiwpl"), # miasma
	preload("uid://hjn3masc2j5q"), # water
	preload("uid://cf8vdy41wb0lk"), # wind
]


static var seconds_turn_increment : float = 1.0


@onready var target : Target = %Target
@onready var magic_glyph : MagicGlyph = %MagicGlyph

@onready var sigil_container : GridContainer = %SigilContainer
@onready var sigil_texture : TextureRect = %SigilTexture
@onready var sigil_name : Label = %SigilName

@onready var turn_count_menu : OptionButton = %TurnCountMenu


func _ready() -> void:
	_populate_sigil_editor()

	Game.target = target


func _populate_sigil_editor() -> void:
	for sigil : Sigil in SIGILS:
		var button : SigilButton = SIGIL_BUTTON_SCENE.instantiate()
		button.sigil = sigil
		sigil_container.add_child(button)

		if magic_glyph != null:
			button.pressed.connect(
				magic_glyph._on_sigil_selected.bind(button.sigil)
			)

		button.pressed.connect(
			_update_sigil_info.bind(button.sigil)
		)

	if magic_glyph != null:
		magic_glyph.spell_selected.connect(
			_update_spell_info
		)

	# Turn count
	for i in range(3):
		turn_count_menu.add_item(str(i + 1))


func _update_spell_info(spell : Spell) -> void:
	_update_sigil_info(spell.sigil)
	turn_count_menu.selected = spell.turn_count - 1


func _update_sigil_info(sigil : Sigil) -> void:
	sigil_texture.texture = sigil.texture
	sigil_name.text = sigil.name
