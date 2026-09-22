extends Node


enum Relationship {
	ADDITIVE, # effect is strengthened according to other effect
	SUBTRACTIVE, # effect is weakened according to other effect
	CONVERSION, # one effect is changed into one other effect when in contact with other effect
	TRANSMUTATION, # two effects are changed into one other effect
}


const FIRE : Sigil = preload("uid://0k4l5lbx5apa")
const WATER : Sigil = preload("uid://hjn3masc2j5q")
const EARTH : Sigil = preload("uid://dgmnu4kavulx2")
const WIND : Sigil = preload("uid://cf8vdy41wb0lk")
const AETHER : Sigil = preload("uid://dqct5kwpciyv8")
const MIASMA : Sigil = preload("uid://c6inqib5eiwpl")


var relationships: Dictionary[Array, Relationship] = {
	[FIRE, WATER]   : Relationship.SUBTRACTIVE,
	[FIRE, EARTH]   : Relationship.TRANSMUTATION,
	[FIRE, WIND]    : Relationship.ADDITIVE,
	[FIRE, AETHER]  : Relationship.ADDITIVE,
	[FIRE, MIASMA]  : Relationship.TRANSMUTATION,

	[WATER, EARTH]  : Relationship.ADDITIVE,
	[WATER, WIND]   : Relationship.CONVERSION,
	[WATER, AETHER] : Relationship.ADDITIVE,
	[WATER, MIASMA] : Relationship.TRANSMUTATION,

	[EARTH, WIND]   : Relationship.CONVERSION,
	[EARTH, AETHER] : Relationship.ADDITIVE,
	[EARTH, MIASMA] : Relationship.TRANSMUTATION,

	[WIND, AETHER]  : Relationship.CONVERSION,
	[WIND, MIASMA]  : Relationship.ADDITIVE,

	[AETHER, MIASMA] : Relationship.SUBTRACTIVE,
}


func _get_relationship(s1 : Sigil, s2 : Sigil) -> Relationship:
	var key : Array[Sigil] = _make_pair(s1, s2)
	return relationships.get(key)


func _make_pair(s1 : Sigil, s2 : Sigil) -> Array[Sigil]:
	if s1.id < s2.id:
		return [s1, s2]
	return [s2, s1]
