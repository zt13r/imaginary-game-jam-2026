class_name Puzzle
extends Control


const EFFECT_BUTTON_SCENE : PackedScene = preload("uid://bch1wjqs2art5")


const LEVELS : Array[Level] = [
	preload("uid://cpa6tvjv23peo"), # level 1
	preload("uid://dppjgxn72q0c8"), # level 2
	preload("uid://2tebcfhbia2k"), # level 3
	preload("uid://boqvu00pafukl"), # level 4
	preload("uid://wwq4lulpp0hr"), # level 7
]


@export var main_game : MainGame = null :
	get:
		if not main_game:
			main_game = get_parent()
		return main_game


var current_level : Level = null
@export var level_index : int = 0

var finished : bool = false


@onready var goal_effects : HBoxContainer = %GoalEffects

@onready var rule_label : Label = %ActualRules

@onready var rulebook : PanelContainer = %Rulebook
@onready var header : PanelContainer = %Header


func _ready() -> void:
	next_level()


func next_level() -> void:
	if finished:
		print("You already won bro")
		return

	for child : Control in goal_effects.get_children():
		if child is EffectButton:
			child.queue_free()

	current_level = LEVELS[level_index]

	for goal_effect : Effect in current_level.goal_effects:
		var button : EffectButton = EFFECT_BUTTON_SCENE.instantiate()
		button.custom_maximum_size = Vector2(32, 32)
		button.effect = goal_effect
		goal_effects.add_child(button)

		button.pressed.connect(
			main_game._update_effect_info.bind(button.effect)
		)

	if not current_level.rules.is_empty(): # has rules
		rulebook.custom_minimum_size = Vector2(0.0, 288.0)
		header.show()
		rule_label.show()

		rule_label.text = ""
		var rule_number : int = 1
		for rule : Rule in current_level.rules:
			var rule_display : String = rule.get_display()
			rule_label.text +=\
				"%d. %s\n" % [rule_number, rule_display]
			rule_number += 1
	else: # level has no rules
		rulebook.custom_minimum_size = Vector2(0.0, 0.0)
		header.hide()
		rule_label.hide()

	level_index += 1
	if level_index >= LEVELS.size():
		finished = true
