@tool
class_name MagicCircle
extends Container


const MAX_SPELL_COUNT : int = 8


@export var radius : float = 64.0 :
	set(value):
		radius = value
		_update_container()

@export_tool_button("Update Container")
var update_container : Callable = func() : _update_container()


func _ready() -> void:
	_update_container()


func _update_container() -> void:
	update_minimum_size()
	queue_sort()


func _notification(what : int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		_arrange_children()


func _arrange_children() -> void:
	var spells : Array[Spell] = []
	for child : Node in get_children():
		if child is Spell:
			spells.append(child as Spell)

	if spells.is_empty():
		return

	if spells.size() > MAX_SPELL_COUNT:
		push_error("Maximum of %d sigils only, and you have %d!" % [MAX_SPELL_COUNT, spells.size()])
		return

	var index : int = 0
	var center : Vector2 = size / 2.0

	for sp : Spell in spells:
		var step : float = TAU / spells.size()
		var angle : float = (index * step)

		var pos : Vector2 = Vector2(
			center.x + cos(angle) * radius,
			center.y + sin(angle) * radius
		)

		var spell_size : Vector2 = sp.get_combined_minimum_size()
		pos -= spell_size / 2.0

		fit_child_in_rect(sp, Rect2(pos, spell_size))
		index += 1
