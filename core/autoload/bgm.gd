extends AudioStreamPlayer


var bgm : AudioStream = preload("uid://wpfi8vnt0612")


func _ready() -> void:
	stream = bgm
	volume_linear = 0.5
	if not bgm.loop:
		finished.connect(play)
	play()
