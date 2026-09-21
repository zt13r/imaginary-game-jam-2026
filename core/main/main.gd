class_name MainGame
extends Node


const SIGIL_BUTTON_SCENE : PackedScene = preload("uid://do33dwe5lth1")

const SIGILS : Array[Sigil] = [
	preload("uid://0k4l5lbx5apa"), # fire
]


static var seconds_turn_increment : float = 1.0


@onready var target_self : Target = %TargetSelf
@onready var target_other : Target = %TargetOther

@onready var sigil_container : GridContainer = %SigilContainer


func _ready() -> void:
	for sigil : Sigil in SIGILS:
		var button : SigilButton = SIGIL_BUTTON_SCENE.instantiate()
		button.texture = sigil.texture
		sigil_container.add_child(button)

	Game.target_self = target_self
	Game.target_other = target_other
