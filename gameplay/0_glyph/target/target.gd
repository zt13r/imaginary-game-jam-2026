class_name Target
extends Control


#                    effect_name, turn_count
var effects : Dictionary[Effect, int] = {}


func _ready() -> void:
	if mouse_filter != MOUSE_FILTER_IGNORE:
		mouse_filter = Control.MOUSE_FILTER_IGNORE


func has_effect(effect : Effect) -> bool:
	if effect in effects:
		return true
	return false


func add_effect(effect : Effect, turn_count : int) -> void:
	effects[effect] = turn_count


func next_turn() -> void:
	var subtractive_pairs : Array[Array] = []
	var new_effects : Dictionary[Effect, int] = effects.duplicate()

	var effect_list : Array[Effect] = effects.keys()

	for i : int in effect_list.size():
		var effect_a : Effect = effect_list[i]

		for j : int in range(i + 1, effect_list.size()):
			var effect_b : Effect = effect_list[j]

			# Skip if current pair has no reaction
			if not ReactionDatabase.has_reaction(effect_a, effect_b):
				continue

			var reaction : Effect =\
				ReactionDatabase.get_reaction(effect_a, effect_b)

			if reaction != null:

				# If effect_a in subtractive_pairs,
				# remove all instances of effect in subtractive_pairs
				for k : int in range(subtractive_pairs.size() - 1, -1, -1):
					var pair : Array = subtractive_pairs[k]
					if effect_a in pair or effect_b in pair:
						subtractive_pairs.remove_at(k)

				# Add new effect
				var new_turn_count : int =\
					max(effects[effect_a], effects[effect_b])
				new_effects[reaction] = new_turn_count

				# Remove effects
				new_effects.erase(effect_a)
				new_effects.erase(effect_b)

			else:
				subtractive_pairs.append([effect_a, effect_b])

	# Subtractive effects
	for effect : Effect in new_effects.duplicate():
		for pair : Array in subtractive_pairs:
			if effect in pair:
				new_effects.erase(effect)

	# Remove effects that are out of turns
	for effect : Effect in new_effects.duplicate():
		var turns_left : int = new_effects[effect] - 1
		if turns_left <= 0:
			new_effects.erase(effect)
		else:
			new_effects[effect] = turns_left

	effects = new_effects
