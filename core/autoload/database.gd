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

	preload("uid://cgtsfeqgchn7i"), # blighted-charred
	preload("uid://c7t17otri47gd"), # blighted-choked
	preload("uid://bndivxvhhg3b8"), # blighted-corrupted
	preload("uid://mptv0vxr8l6i"), # blighted-diseased
	preload("uid://k7a41rb8ghgr"), # blighted-disoriented
	preload("uid://dkmothw5kac4k"), # blighted-drenched
	preload("uid://bhvcb0ueotmcr"), # blighted-frozen
	preload("uid://bylgipycvigxs"), # blighted-muddied
	preload("uid://dv4o8w2jb1pwb"), # blighted-rooted
	preload("uid://cqur2hfvltifl"), # blighted-scorched
	preload("uid://br272a8dl6uqk"), # blighted-shocked
	preload("uid://b3jbcrb8qlbuk"), # charred-choked
	preload("uid://dg8qwxdp1qasw"), # charred-corrupted
	preload("uid://fh2oxkgwn8k6"), # charred-diseased
	preload("uid://dtbq85vmbjr8b"), # charred-disoriented
	preload("uid://bjd8go4mrt4m4"), # charred-drenched
	preload("uid://b01cp0tfysc5e"), # charred-frozen
	preload("uid://b87afgy8aeikn"), # charred-muddied
	preload("uid://cm2ro25qnbrot"), # charred-rooted
	preload("uid://qu0o6p00jb3s"), # charred-scorched
	preload("uid://y0i6kv2dabsp"), # charred-shocked
	preload("uid://wp730uatuixo"), # choked-corrupted
	preload("uid://dceyh4k7ipnhj"), # choked-diseased
	preload("uid://bwktkh66nivfa"), # choked-disoriented
	preload("uid://dsywgug7xm3c1"), # choked-drenched
	preload("uid://c1x5128d88q6q"), # choked-frozen
	preload("uid://rjk0j88r4t28"), # choked-muddied
	preload("uid://d2ha2nbieujis"), # choked-rooted
	preload("uid://b8b2gfqwv5oxu"), # choked-scorched
	preload("uid://grw0rmop5fbr"), # choked-shocked
	preload("uid://cnh3y2fa8er7b"), # corrupted-diseased
	preload("uid://5vnurvfbcvnu"), # corrupted-disoriented
	preload("uid://lb2e1x8uxnwx"), # corrupted-drenched
	preload("uid://bswk6er1ht5fw"), # corrupted-frozen
	preload("uid://cfhr6bw7v8a6l"), # corrupted-muddied
	preload("uid://qqkb83dt5je6"), # corrupted-rooted
	preload("uid://ddkhdfouwjb14"), # corrupted-scorched
	preload("uid://bw5t6fwclkmw5"), # corrupted-shocked
	preload("uid://bxp7ou67f5njh"), # diseased-disoriented
	preload("uid://coc0ms63jxiyi"), # diseased-drenched
	preload("uid://bwmfi3f6o7pu0"), # diseased-frozen
	preload("uid://iynbacffpqp7"), # diseased-muddied
	preload("uid://b4kxdscrid34q"), # diseased-rooted
	preload("uid://c86tj03m1u2w6"), # diseased-scorched
	preload("uid://qthriicdv1um"), # diseased-shocked
	preload("uid://cqiqpnumwl7uy"), # disoriented-drenched
	preload("uid://b5yt5wxcv00kl"), # disoriented-frozen
	preload("uid://koo4dhojpvnl"), # disoriented-muddied
	preload("uid://cqsrk36nocctb"), # disoriented-rooted
	preload("uid://pt7jacd4wmye"), # disoriented-scorched
	preload("uid://dvrfjwh7v4tlp"), # disoriented-shocked
	preload("uid://bxp8mu31kmqcw"), # drenched-frozen
	preload("uid://p4qmrbre3spi"), # drenched-muddied
	preload("uid://dgoy85nnmehvt"), # drenched-rooted
	preload("uid://be1e4ijblvudl"), # drenched-scorched
	preload("uid://c5bh64k150iku"), # drenched-shocked
	preload("uid://bamef61kjp0yr"), # frozen-muddied
	preload("uid://pw0kb1b2uimf"), # frozen-rooted
	preload("uid://b3tcifcsvu7sw"), # frozen-scorched
	preload("uid://dx8cfs7kocs8c"), # frozen-shocked
	preload("uid://brnylbvcst1dh"), # muddied-rooted
	preload("uid://dxm4lg7cstypy"), # muddied-scorched
	preload("uid://cbxa8qec8ngyd"), # muddied-shocked
	preload("uid://v22v4f4gn1x"), # rooted-scorched
	preload("uid://ce3bdwbv0x7s3"), # rooted-shocked
	preload("uid://cq6i8s6a5tnvl"), # scorched-shocked
]


var reactions : Dictionary[String, Effect] = {}
var library : Dictionary[Effect, Array] = {}


func _ready() -> void:
	_build_reactions()
	_build_library()


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
		var result : Effect = reaction.result

		reactions[key] = result


# In-game Effect library
func _build_library() -> void:
	for reaction : Reaction in resources:
		var result : Effect = reaction.result
		if not library.has(result):
			library[result] = []
		library[result].append(reaction)
	print(format(library))



func format(_library : Dictionary[Effect, Array]) -> String:
	var formatted : String = ""
	for effect : Effect in _library:
		formatted += effect.name + ": "
		var _reactions : Array = _library[effect]
		for reaction : Reaction in _reactions:
			formatted += "[%s-%s], " % [reaction.effect_a.name, reaction.effect_b.name]
		formatted += "\n"
	return formatted
