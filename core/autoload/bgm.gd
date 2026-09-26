extends AudioStreamPlayer


var bgm : AudioStream = preload("uid://wpfi8vnt0612")


func _ready() -> void:
	stream = bgm
	if not bgm.loop:
		finished.connect(play)
	play()
