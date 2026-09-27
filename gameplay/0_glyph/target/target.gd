class_name Target
extends TextureRect


const EFFECT_BUTTON_SCENE : PackedScene = preload("uid://bch1wjqs2art5")

const HURT_SFX : Array[AudioStream] = [
	preload("uid://dd1adogt0ug0r"),
	preload("uid://nvrqu4116d4g"),
	preload("uid://7obhp5x14sk8"),
	preload("uid://b22kxw6pq6x45"),
	preload("uid://bhjrujgt3j77n"),
	preload("uid://c8yj7s4uwb4jv"),
	preload("uid://c7kwb4sfpqh4n"),
	
]


#                    effect_name, turn_count
var effects : Dictionary[Effect, int] = {}


@onready var effect_display : GridContainer = %EffectDisplay
@onready var hurt : AudioStreamPlayer = %HurtSFX

#@onready var debug_effects_label: Label = %DebugEffectsLabel


func _ready() -> void:
	if mouse_filter != MOUSE_FILTER_IGNORE:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	hurt.volume_linear = 0.6


func has_effect(effect : Effect) -> bool:
	if effect in effects:
		return true
	return false


func add_effect(effect : Effect, turn_count : int) -> void:
	effects[effect] = turn_count

	var button : EffectButton =\
			EFFECT_BUTTON_SCENE.instantiate()
	button.disabled = true
	button.effect = effect
	effect_display.add_child(button)
	#debug_effects_label.text = "Effects:" + format_effects(effects)

	hurt.stream = HURT_SFX.pick_random()
	hurt.pitch_scale = randf_range(0.9, 1.1)
	hurt.play()


func clear_effects() -> void:
	effects.clear()
	#debug_effects_label.text = "Effects:"


func end_turn() -> void:
	var new_effects : Dictionary[Effect, int] = effects.duplicate()
	var reactions_this_turn : Array[Effect] = []

	var effect_list : Array[Effect] = effects.keys()

	for i : int in effect_list.size():
		var effect_a : Effect = effect_list[i]

		for j : int in range(i + 1, effect_list.size()):
			var effect_b : Effect = effect_list[j]

			# Skip if current pair has no reaction
			if not Database.has_reaction(effect_a, effect_b):
				continue

			var reaction : Effect =\
				Database.get_reaction(effect_a, effect_b)

			if reaction != null and not has_effect(reaction):
				# Add new effect
				var new_turn_count : int = 3
					#max(effects[effect_a], effects[effect_b])

				new_effects[reaction] = new_turn_count
				reactions_this_turn.append(reaction)

				# Remove effects
				#new_effects.erase(effect_a)
				#new_effects.erase(effect_b)

	# Remove effects that are out of turns
	for effect : Effect in new_effects.duplicate():
		if effect in reactions_this_turn:
			continue
		var turns_left : int = new_effects[effect] - 1
		if turns_left <= 0:
			new_effects.erase(effect)
		else:
			new_effects[effect] = turns_left

	for child : EffectButton in effect_display.get_children():
		child.queue_free()

	for effect : Effect in new_effects:
		var button : EffectButton =\
			EFFECT_BUTTON_SCENE.instantiate()
		button.disabled = true
		button.effect = effect
		effect_display.add_child(button)

	effects = new_effects

	hurt.stream = HURT_SFX.pick_random()
	hurt.pitch_scale = randf_range(0.9, 1.1)
	hurt.play()

	#debug_effects_label.text = "Effects:" + format_effects(effects)


func format_effects(new_effects : Dictionary[Effect, int]) -> String:
	var formatted : String = ""
	for effect in new_effects:
		var turns_left : int = new_effects[effect]
		formatted += "\n" + str(effect.name) + " : " + str(turns_left) 
	return formatted
