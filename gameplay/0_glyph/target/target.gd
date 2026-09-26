class_name Target
extends TextureRect


const EFFECT_BUTTON_SCENE : PackedScene = preload("uid://bch1wjqs2art5")


#                    effect_name, turn_count
var effects : Dictionary[Effect, int] = {}


@onready var effect_display : GridContainer = %EffectDisplay

#@onready var debug_effects_label: Label = %DebugEffectsLabel


func _ready() -> void:
	if mouse_filter != MOUSE_FILTER_IGNORE:
		mouse_filter = Control.MOUSE_FILTER_IGNORE


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


func clear_effects() -> void:
	effects.clear()
	#debug_effects_label.text = "Effects:"


func end_turn() -> void:
	var new_effects : Dictionary[Effect, int] = effects.duplicate()

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

				# Remove effects
				#new_effects.erase(effect_a)
				#new_effects.erase(effect_b)

	# Remove effects that are out of turns
	for effect : Effect in new_effects.duplicate():
		var turns_left : int = new_effects[effect] - 1
		if turns_left < 0:
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

	#debug_effects_label.text = "Effects:" + format_effects(effects)


func format_effects(new_effects : Dictionary[Effect, int]) -> String:
	var formatted : String = ""
	for effect in new_effects:
		var turns_left : int = new_effects[effect]
		formatted += "\n" + str(effect.name) + " : " + str(turns_left) 
	return formatted
