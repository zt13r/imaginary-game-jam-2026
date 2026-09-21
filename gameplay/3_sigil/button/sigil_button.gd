class_name SigilButton
extends TextureButton


@export var texture : Texture2D = null


@onready var icon : TextureRect = %Icon


func _ready() -> void:
	icon.texture = texture
