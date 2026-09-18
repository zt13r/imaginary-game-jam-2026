class_name MainGame
extends Node


static var seconds_turn_increment : float = 1.0


@onready var target_self : Target = %TargetSelf
@onready var target_other : Target = %TargetOther


func _ready() -> void:
	Game.target_self = target_self
	Game.target_other = target_other
