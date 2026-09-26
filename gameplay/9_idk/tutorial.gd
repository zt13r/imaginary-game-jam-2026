class_name Tutorial
extends Control


#             level_index   { String : Vector2 }
const TEXT : Dictionary[int, Dictionary] = {
	1 : {
		"Hi, I'm the tutorial" : Vector2(800.0, 280.0),
		"I live in a realm beyond\nyour comprehension" : Vector2(800.0, 280.0),
		"Select a spell by clicking\non it, it will shine gold" : Vector2(800.0, 280.0),
		"<<< Edit a spell here" : Vector2(368.0, 200.0),
		"<<< Edit a spell's\nsigil (or element)" : Vector2(368.0, 256.0),
		"<<< Edit how many\nturns the sigil's\neffect lasts" : Vector2(360.0, 288.0),
		"Effects in the same turn will merge for a new effect in the next turn" : Vector2(806.0, 280.0),
		"Effects will only disappear\nafter their turns run out" : Vector2(806.0, 280.0),
		"Effect turns include the turn it was added" : Vector2(806.0, 280.0),
		"<<< Mish-mash spells,\ntry to get these specific\neffects in the end" : Vector2(304.0, 432.0),
		"<<< You may see all\neffects here, and which\ncombinations make new effects" : Vector2(312.0, 32.0),
		"Click on an effect's\nicon to shortcut\nopen its info" : Vector2(368.0, 256.0),
		"Click the 'Cast' button\nto execute all spells\nCLOCKWISE" : Vector2(388.0, 256.0),
		"Yeah that's about it;\nI'll come back later on though.\nI hope you'll have fun" : Vector2(806.0, 280.0)
	},

	3 : {
		"Hey there, me again!\nGreat that you're\nstill here" : Vector2(824.0, 268.0),
		"<<< Anyway, the\nRulebook was added" : Vector2(304.0, 527.0),
		"It was designed to make\nyour life more difficult" : Vector2(304.0, 527.0),
		"Along with the target\neffects, your spells must\nnow also adhere to whatever\nis written on here" : Vector2(304.0, 474.0),
		"It's pretty neat!\nGod bless" : Vector2(370.0, 564.0),
	},
}
#                      


@export var puzzle : Puzzle = null


var current_step : int = 0


@onready var label : Label = %TutorialLabel


func _gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and \
		event.button_index == MOUSE_BUTTON_LEFT:
			_advance_tutorial()


func _advance_tutorial() -> void:
	current_step += 1

	if current_step < TEXT.get(puzzle.level_index, {}).size():
		show_text()
	else:
		_finish_tutorial()


func show_text() -> void:
	if visible == false:
		show()
	if label.visible == false:
		label.show()
	var string_and_pos : Dictionary =\
		TEXT.get(puzzle.level_index, {})
	if string_and_pos.is_empty():
		return
	var strings : Array = string_and_pos.keys()
	var positions : Array = string_and_pos.values()
	label.text = strings.get(current_step)
	label.global_position = positions.get(current_step)


func _finish_tutorial() -> void:
	current_step = 0
	hide()
