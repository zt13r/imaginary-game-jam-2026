class_name MainGame
extends Node


const SIGIL_BUTTON_SCENE : PackedScene = preload("uid://do33dwe5lth1")
const FRAME_BUTTON_SCENE : PackedScene = preload("uid://b6rh1vntwsoyt")

const SIGILS : Array[Sigil] = [
	preload("uid://0k4l5lbx5apa"), # fire
]

const FRAMES : Array[Frame] = [
	preload("uid://bsh5gkkxtblsi"), # execution
	preload("uid://hogyagm4nm8u"), # decision
]


static var seconds_turn_increment : float = 1.0


@onready var target_self : Target = %TargetSelf
@onready var target_other : Target = %TargetOther

@onready var sigil_container : GridContainer = %SigilContainer
@onready var frame_container : GridContainer = %FrameContainer


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

	# Frame editor
	for frame : Frame in FRAMES:
		var button : FrameButton = FRAME_BUTTON_SCENE.instantiate()
		button.texture = frame.texture
		frame_container.add_child(button)
