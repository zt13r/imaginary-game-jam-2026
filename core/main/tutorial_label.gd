class_name TutorialLayer
extends CanvasLayer


#             level_index   { String : Vector2 }
const TEXT : Dictionary[int, Dictionary] = {
	0 : {
		"Hi, I'm your tutorial guy" : Vector2(),
		"I live in a realm beyond your comprehension" : Vector2(),
	}
}
#                      


@export var puzzle : Puzzle = null


var current_step : int = 0


@onready var label : Label = %TutorialLabel


func _ready() -> void:
	_show_text()


func _gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and \
		event.button_index == MOUSE_BUTTON_LEFT:
			_advance_tutorial()


func _advance_tutorial() -> void:
	current_step += 1

	if current_step > TEXT[puzzle.level_index].size():
		_show_text()
	else:
		_finish_tutorial()


func _show_text() -> void:
	var pos : Vector2 = TEXT[puzzle.level_index][current_step]
	label.text = TEXT[puzzle.level_index].find_key(pos)
	label.global_position = pos


func _finish_tutorial() -> void:
	hide()
