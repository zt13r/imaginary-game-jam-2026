@tool
class_name MagicCircle
extends Container


const MAX_SIGIL_COUNT : int = 8


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
	var sigil_nodes : Array[SigilNode] = []
	for child : Node in get_children():
		if child is SigilNode:
			sigil_nodes.append(child as SigilNode)

	if sigil_nodes.is_empty():
		return

	if sigil_nodes.size() > MAX_SIGIL_COUNT:
		push_error("Maximum of %d sigils only, and you have %d!" % [MAX_SIGIL_COUNT, sigil_nodes.size()])
		return

	var index : int = 0
	var center : Vector2 = size / 2.0

	for sigil : SigilNode in sigil_nodes:
		var step : float = TAU / sigil_nodes.size()
		var angle : float = (index * step)

		var pos : Vector2 = Vector2(
			center.x + cos(angle) * radius,
			center.y + sin(angle) * radius
		)

		var sigil_size : Vector2 = sigil.get_combined_minimum_size()
		pos -= sigil_size / 2.0

		fit_child_in_rect(sigil, Rect2(pos, sigil_size))
		index += 1
