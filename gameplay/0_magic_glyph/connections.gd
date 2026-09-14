@tool
class_name Connections
extends Control


@export_group("Quadratic Bezier Test")
@export var start : Vector2 = Vector2(100, 100) :
	set(value):
		start = value
		queue_redraw()
@export var curve : Vector2 = Vector2(200, 50) :
	set(value):
		curve = value
		queue_redraw()
@export var end : Vector2 = Vector2(300, 100) :
	set(value):
		end = value
		queue_redraw()


func _draw() -> void:
	var previous_point : Vector2 = start

	for i in range(1, 21):
		var t : float = float(i) / 20.0
		var point : Vector2 = quadratic_bezier(start, curve, end, t)

		draw_line(previous_point, point, Color.WHITE, 4.0)
		previous_point = point


func quadratic_bezier(
	start_point : Vector2,
	curve_point : Vector2,
	end_point : Vector2,
	t : float
) -> Vector2:
	return (
		(((1.0 - t) * (1.0 - t)) * start_point) +
		(((2.0 * (1.0 - t)) * t) * curve_point) +
		((t * t) * end_point)
	)
