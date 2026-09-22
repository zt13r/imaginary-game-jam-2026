class_name Effect
extends Resource


@export var display_name : String = ""
@export var reactions : Array[Reaction] = []


func check(effect_1 : Effect, effect_2 : Effect) -> Effect:
	for r in reactions:
		if (
			(r.effect_1 == effect_1 and r.effect_2 == effect_2)
			or 
			(r.effect_1 == effect_2 and r.effect_2 == effect_1)
		):
			return r.result
	return null
