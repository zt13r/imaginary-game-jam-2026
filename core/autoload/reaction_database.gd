extends Node


var resources: Array[Reaction] = [
	preload("uid://c7cs7g2reu5vp"), # airborne-awakened
	preload("uid://dtfqnf3l6cmo"), # airborne-tainted
	preload("uid://qfh2paknb43e"), # awakened-tainted
	preload("uid://imqai4pb1nhb"), # burnt-airborne
	preload("uid://io8xy0t5r7j4"), # burnt-awakened
	preload("uid://cfjjvp5og3nsj"), # burnt-grounded
	preload("uid://dixwtjj0bgnmk"), # burnt-soaked
	preload("uid://cegihe2lvsmbc"), # burnt-tainted
	preload("uid://4p63ahuyhuc"), # grounded-airborne
	preload("uid://17run6tk672q"), # grounded-awakened
	preload("uid://cdwerht38cjqd"), # grounded-tainted
	preload("uid://sex6ya7icpnn"), # soaked-airborne
	preload("uid://cmwuqd85afibm"), # soaked-awakened
	preload("uid://pg7wgkt4v0tm"), # soaked-grounded
	preload("uid://m3qvrk8ffype"), # soaked-tainted
]


var reactions : Dictionary[String, Effect] = {}


func _ready() -> void:
	_build_reactions()


func has_reaction(effect_a : Effect, effect_b : Effect) -> bool:
	var key : String = make_key(effect_a, effect_b)
	return key in reactions


func get_reaction(effect_a : Effect, effect_b : Effect) -> Effect:
	var key : String = make_key(effect_a, effect_b)
	return reactions.get(key, null)


func make_key(effect_a : Effect, effect_b : Effect) -> String:
	var names : Array[String] = [effect_a.name.to_lower(), effect_b.name.to_lower()]
	names.sort()
	return names[0] + "-" + names[1]


func _build_reactions() -> void:
	for reaction : Reaction in resources:
		var key : String = make_key(
			reaction.effect_a,
			reaction.effect_b
		)
		var value : Effect = reaction.result

		reactions[key] = value
