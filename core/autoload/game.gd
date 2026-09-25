extends Node


var target : Target = null


### DEBUG BEYOND THIS POINT, probably
const REACTIONS : Array[Array] = [
	["Blighted", "Charred", "Withered"],
	["Blighted", "Choked", "Suffocated"],
	["Blighted", "Corrupted", "Withered"],
	["Blighted", "Diseased", "Poisoned"],
	["Blighted", "Disoriented", "Hypnotized"],
	["Blighted", "Drenched", "Scalded"],
	["Blighted", "Frozen", "Unconscious"],
	["Blighted", "Muddied", "Bleeding"],
	["Blighted", "Rooted", "Bleeding"],
	["Blighted", "Scorched", "Possessed"],
	["Blighted", "Shocked", "Deafened"],

	["Charred", "Choked", "Blinded"],
	["Charred", "Corrupted", "Enraged"],
	["Charred", "Diseased", "Scalded"],
	["Charred", "Disoriented", "Dazed"],
	["Charred", "Drenched", "Electrified"],
	["Charred", "Frozen", "Enraged"],
	["Charred", "Muddied", "Scalded"],
	["Charred", "Rooted", "Petrified"],
	["Charred", "Scorched", "Enraged"],
	["Charred", "Shocked", "Bleeding"],

	["Choked", "Corrupted", "Cursed"],
	["Choked", "Diseased", "Weakened"],
	["Choked", "Disoriented", "Terrified"],
	["Choked", "Drenched", "Deafened"],
	["Choked", "Frozen", "Silenced"],
	["Choked", "Muddied", "Suffocated"],
	["Choked", "Rooted", "Suffocated"],
	["Choked", "Scorched", "Suffocated"],
	["Choked", "Shocked", "Silenced"],

	["Corrupted", "Diseased", "Poisoned"],
	["Corrupted", "Disoriented", "Dazed"],
	["Corrupted", "Drenched", "Drained"],
	["Corrupted", "Frozen", "Hypnotized"],
	["Corrupted", "Muddied", "Cursed"],
	["Corrupted", "Rooted", "Weakened"],
	["Corrupted", "Scorched", "Enraged"],
	["Corrupted", "Shocked", "Cursed"],

	["Diseased", "Disoriented", "Weakened"],
	["Diseased", "Drenched", "Hypnotized"],
	["Diseased", "Frozen", "Drained"],
	["Diseased", "Muddied", "Poisoned"],
	["Diseased", "Rooted", "Drained"],
	["Diseased", "Scorched", "Poisoned"],
	["Diseased", "Shocked", "Terrified"],

	["Disoriented", "Drenched", "Unconscious"],
	["Disoriented", "Frozen", "Paralyzed"],
	["Disoriented", "Muddied", "Confused"],
	["Disoriented", "Rooted", "Dazed"],
	["Disoriented", "Scorched", "Confused"],
	["Disoriented", "Shocked", "Deafened"],

	["Drenched", "Frozen", "Frigid"],
	["Drenched", "Muddied", "Numbed"],
	["Drenched", "Rooted", "Enchanted"],
	["Drenched", "Scorched", "Scalded"],
	["Drenched", "Shocked", "Electrified"],

	["Frozen", "Muddied", "Frigid"],
	["Frozen", "Rooted", "Paralyzed"],
	["Frozen", "Scorched", "Blinded"],
	["Frozen", "Shocked", "Silenced"],

	["Muddied", "Rooted", "Petrified"],
	["Muddied", "Scorched", "Blinded"],
	["Muddied", "Shocked", "Enchanted"],

	["Rooted", "Scorched", "Unconscious"],
	["Rooted", "Shocked", "Paralyzed"],

	["Scorched", "Shocked", "Electrified"],
]


func _ready() -> void:
	for data in REACTIONS:
		var a_name : String = data[0].to_lower()
		var b_name : String = data[1].to_lower()
		var result_name : String = data[2].to_lower()

		var a_path : String = "res://gameplay/4_effects/resources/derived/1/%s.tres" % a_name
		var b_path : String = "res://gameplay/4_effects/resources/derived/1/%s.tres" % b_name
		var result_path : String = "res://gameplay/4_effects/resources/derived/2/%s.tres" % result_name

		if not FileAccess.file_exists(a_path):
			print("Path to %s unavailable." % a_name)
			continue
		if not FileAccess.file_exists(b_path):
			print("Path to %s unavailable." % b_name)
			continue
		if not FileAccess.file_exists(result_path):
			print("Path to %s unavailable." % result_name)
			continue

		var reaction : Reaction = Reaction.new()

		reaction.effect_a = load(a_path)
		reaction.effect_b = load(b_path)
		reaction.result = load(result_path)

		var path : String =\
			"res://gameplay/5_reactions/resources/derived/2/%s_%s.tres" % [a_name, b_name]

		ResourceSaver.save(reaction, path)

	print("GENERATED.")
