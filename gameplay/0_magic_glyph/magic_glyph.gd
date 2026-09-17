class_name MagicGlyph
extends Control


const SPELL_SCENE : PackedScene = preload("uid://bn0pur841hkr6")


var current_ring : RingContainer = null :
	get:
		if not current_ring:
			current_ring = outer_spells
		return current_ring
var selected_spell : Spell = null


@onready var outer_spells : RingContainer = %OuterSpells
@onready var inner_spells : RingContainer = %InnerSpells


func _ready() -> void:
	for spell : Spell in outer_spells.get_children():
		spell.spell_selected.connect(_on_spell_selected)
	for spell : Spell in inner_spells.get_children():
		spell.spell_selected.connect(_on_spell_selected)


func _add_spell() -> void:
	if current_ring == null:
		push_error("Current RingContainer reference is null.")
		return

	if current_ring.spells.size() >= current_ring.max_spell_count:
		return

	var spell : Spell = SPELL_SCENE.instantiate() as Spell
	spell.spell_selected.connect(_on_spell_selected)
	current_ring.spells.append(spell)

	print(current_ring.spells)

	# Probably debug idk
	if current_ring.spells.size() > 1:
		var prev_spell_index : int = current_ring.spells.find(spell) - 1
		current_ring.spells[prev_spell_index].then_spell = spell

		print("%s then_spell -> %s" % [
			current_ring.spells[prev_spell_index].name,
			current_ring.spells[prev_spell_index].then_spell.name
		])

	current_ring.add_child(spell)

	# Debug, color spell
	if spell.get_parent() == current_ring:
		spell.modulate = Color.DARK_GOLDENROD


func _delete_selected_spell() -> void:
	if current_ring == null:
		push_error("Current RingContainer reference is null.")
		return

	if is_instance_valid(selected_spell):
		current_ring.spells.erase(selected_spell)
		selected_spell.queue_free()
		selected_spell = null


func _on_spell_selected(spell : Spell) -> void:
	# Debug, remove color of previous ring and selected spell
	if current_ring != null:
		if spell.get_parent() is RingContainer:
			if current_ring != spell.get_parent():
				for sp : Spell in current_ring.get_children():
					sp.modulate = Color.WHITE
		if selected_spell != spell and selected_spell != null:
			selected_spell.modulate = Color.WHITE

	if spell.get_parent() is RingContainer:
		current_ring = spell.get_parent()
	selected_spell = spell

	# Debug, color current ring
	for sp : Spell in current_ring.get_children():
		sp.modulate = Color.DARK_GOLDENROD

	# Debug, color selected spell
	selected_spell.modulate = Color.GOLD


func _on_add_spell_button_pressed() -> void:
	_add_spell()


func _on_delete_selected_spell_button_pressed() -> void:
	_delete_selected_spell()


func _on_cast_button_pressed() -> void:
	outer_spells.spells.front().execute()
