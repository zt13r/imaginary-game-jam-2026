extends Node


const DURATION : float = 2.0


var target : Target = null
var errors : VBoxContainer = null

var labels : Dictionary[Label, float] = {}


func _process(delta: float) -> void:
	for label : Label in labels:
		labels[label] = labels[label] - delta
		if labels[label] <= 0.0:
			labels.erase(label)
			label.queue_free()


func add_error(text : String) -> void:
	var label : Label = Label.new()
	label.text = text
	labels[label] = DURATION
	errors.add_child(label)
