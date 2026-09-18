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
		outer_spells.spells.append(spell)
		spell.spell_selected.connect(_on_spell_selected)
		spell.get_previous_spell_then_spell(current_ring.spells)

	for spell : Spell in inner_spells.get_children():
		inner_spells.spells.append(spell)
		spell.spell_selected.connect(_on_spell_selected)
		spell.get_previous_spell_then_spell(current_ring.spells)


func _add_spell() -> void:
	if current_ring == null:
		push_error("Current RingContainer reference is null.")
		return

	if current_ring.spells.size() >= current_ring.max_spell_count:
		return

	var spell : Spell = SPELL_SCENE.instantiate() as Spell
	spell.spell_selected.connect(_on_spell_selected)
	current_ring.spells.append(spell)

	current_ring.add_child(spell)

	var previous_index : int =\
		posmod(current_ring.spells.find(self) - 1, current_ring.spells.size())
	spell.previous_spell = current_ring.spells[previous_index]


func _delete_selected_spell() -> void:
	if current_ring == null:
		push_error("Current RingContainer reference is null.")
		return

	if current_ring.spells.size() == current_ring.min_spell_count:
		#push_error("Hey big man, selected ring needs at least %d spells." % current_ring.min_spell_count)
		return

	if is_instance_valid(selected_spell):
		current_ring.spells.erase(selected_spell)
		selected_spell.then_spell.modulate = Color.WHITE

		# The spell that had this deleted spell
		# as its then_ and else_ spells, update before deletion
		selected_spell.previous_spell.get_previous_spell_then_spell(current_ring.spells)
		if selected_spell.previous_spell.frame.type == Frame.Type.DECISION:
			selected_spell.previous_spell.else_spell = null

		selected_spell.queue_free()
		selected_spell = null


func _on_spell_selected(spell : Spell) -> void:
	# Debug, remove color selected spell
	if current_ring != null:
		if selected_spell != spell and selected_spell != null:
			selected_spell.next_spell.modulate = Color.WHITE
			selected_spell.modulate = Color.WHITE

	if spell.get_parent() is RingContainer:
		current_ring = spell.get_parent()
	selected_spell = spell

	# Debug, color selected spell
	selected_spell.modulate = Color.GOLD
	selected_spell.then_spell.modulate = Color.DARK_GOLDENROD


func _on_add_spell_button_pressed() -> void:
	_add_spell()


func _on_delete_selected_spell_button_pressed() -> void:
	_delete_selected_spell()


func _on_cast_button_pressed() -> void:
	outer_spells.spells.front().execute()
