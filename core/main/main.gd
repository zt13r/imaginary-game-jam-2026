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


@onready var target_self : Target = %TargetSelf
@onready var target_other : Target = %TargetOther

@onready var sigil_container : GridContainer = %SigilContainer


func _ready() -> void:
	_populate_spell_editor()

	Game.target_self = target_self
	Game.target_other = target_other


func _populate_spell_editor() -> void:
	# Sigil editor
	for sigil : Sigil in SIGILS:
		var button : SigilButton = SIGIL_BUTTON_SCENE.instantiate()
		button.texture = sigil.texture
		sigil_container.add_child(button)
