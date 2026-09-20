class_name MagicGlyph
extends Control


const SPELL_SCENE : PackedScene = preload("uid://bn0pur841hkr6")

const SIGIL_RESOURCES : Array[Sigil] = [
	preload("uid://0k4l5lbx5apa"), # Fire
]


@export var sigil_button : OptionButton = null
@export var turn_count_button : OptionButton = null
@export var target_button : OptionButton = null


var current_ring : RingContainer = null :
	get:
		if not current_ring:
			current_ring = outer_spells
		return current_ring
var selected_spell : Spell = null


@onready var connections : Connections = %Connections

@onready var outer_spells : RingContainer = %OuterSpells
@onready var inner_spells : RingContainer = %InnerSpells


func _ready() -> void:
	_init_spell_stuff()
	_assign_initial_spell_connections()
	_populate_sigil_button()
	_populate_turn_count_button()
	_populate_target_button()
	connections.redraw()


func _init_spell_stuff() -> void:
	# Append spells to respective ring arrays and connect signals
	for spell : Spell in outer_spells.get_children():
		outer_spells.spells.append(spell)
		spell.spell_selected.connect(_on_spell_selected)
	for spell : Spell in inner_spells.get_children():
		inner_spells.spells.append(spell)
		spell.spell_selected.connect(_on_spell_selected)


func _assign_initial_spell_connections() -> void:
	# Get each spell's previous spell's then spells (???)
	for spell : Spell in outer_spells.spells:
		spell.get_previous_spell_then_spell(outer_spells.spells)
	for spell : Spell in inner_spells.spells:
		spell.get_previous_spell_then_spell(inner_spells.spells)


func _populate_sigil_button() -> void:
	for i in range(SIGIL_RESOURCES.size()):
		var sigil : Sigil = SIGIL_RESOURCES[i]
		sigil_button.add_item(sigil.name)
		sigil_button.set_item_metadata(i, sigil)


func _populate_turn_count_button() -> void:
	for i in range(Spell.MIN_TURN_COUNT, Spell.MAX_TURN_COUNT + 1):
		turn_count_button.add_item(str(i), i)


func _populate_target_button() -> void:
	for i in range(Spell.SpellTarget.size()):
		target_button.add_item(
			str(Spell.SpellTarget.find_key(i))
		)


func _add_spell() -> void:
	if current_ring == null:
		push_error("Current RingContainer reference is null.")
		return

	if current_ring.spells.size() >= current_ring.max_spell_count:
		#push_error("Hey big man, selected ring maximum of %d spells." % current_ring.max_spell_count)
		return

	var spell : Spell = SPELL_SCENE.instantiate() as Spell
	spell.spell_selected.connect(_on_spell_selected)
	current_ring.spells.append(spell)

	current_ring.add_child(spell)

	var previous_index : int =\
		posmod(current_ring.spells.find(spell) - 1, current_ring.spells.size())
	spell.previous_spell = current_ring.spells[previous_index]
	spell.get_previous_spell_then_spell(current_ring.spells)

	if spell.then_spell == null:
		var next_index : int =\
			posmod(current_ring.spells.find(spell) + 1, current_ring.spells.size())
		spell.then_spell = current_ring.spells[next_index]

	# Update first spell's previous spell
	current_ring.spells.front().previous_spell = spell

	connections.redraw()


func _delete_selected_spell() -> void:
	if current_ring == null:
		push_error("Current RingContainer reference is null.")
		return

	if current_ring.spells.size() <= current_ring.min_spell_count:
		#push_error("Hey big man, selected ring needs at least %d spells." % current_ring.min_spell_count)
		return

	if is_instance_valid(selected_spell):
		current_ring.spells.erase(selected_spell)
		selected_spell.then_spell.modulate = Color.WHITE

		# Think LinkedList node removal:
		# reconnect neighboring nodes and all that stuff
		selected_spell.previous_spell.then_spell = selected_spell.then_spell
		if selected_spell.previous_spell.frame.type == Frame.Type.DECISION:
			selected_spell.previous_spell.else_spell = null
		selected_spell.then_spell.previous_spell = selected_spell.previous_spell

		selected_spell.queue_free()
		selected_spell = null

	await get_tree().process_frame
	connections.redraw()


func _on_spell_selected(spell : Spell) -> void:
	# Debug, reset color of selected spell
	if selected_spell != spell and selected_spell != null:
		selected_spell.then_spell.modulate = Color.WHITE
		selected_spell.modulate = Color.WHITE

	if spell.get_parent() is RingContainer:
		current_ring = spell.get_parent()
	else:
		push_error("Selected spell's parent is somehow NOT a RingContainer.")

	selected_spell = spell

	# Update SpellCustomizer UI buttons
	sigil_button.select(
		sigil_button.get_item_index(selected_spell.sigil_id)
	)
	turn_count_button.select(
		turn_count_button.get_item_index(selected_spell.turn_count_id)
	)
	target_button.select(
		target_button.get_item_index(selected_spell.target_id)
	)

	# Debug, color selected spell
	selected_spell.modulate = Color.GOLD


func _on_add_spell_button_pressed() -> void:
	_add_spell()


func _on_delete_selected_spell_button_pressed() -> void:
	_delete_selected_spell()


func _on_cast_button_pressed() -> void:
	# Temporary errors,
	# should be moved to UI display
	for spell : Spell in outer_spells.spells:
		if spell.frame == null:
			push_error(spell.name, " Frame is null.")
			return
		if spell.sigil == null:
			push_error(spell.name, " Sigil is null.")
			return
		if spell.then_spell == null:
			push_error(spell.name, " ThenSpell is null.")
			return
		if spell.else_spell == null and spell.frame.type == Frame.Type.DECISION:
			push_error(spell.name, " ElseSpell is null.")
			return

	# Debug, reset colors before casting
	# Because there is also coloring during casting idk
	# What
	for spell : Spell in outer_spells.spells:
		spell.modulate = Color.WHITE
	for spell : Spell in inner_spells.spells:
		spell.modulate = Color.WHITE

	outer_spells.spells.front().cast()


func _on_sigil_button_item_selected(index : int) -> void:
	# Temporary error,
	# should be moved to UI display
	if selected_spell == null:
		push_error("No spell selected, can't edit spell.")
		return

	selected_spell.sigil = sigil_button.get_item_metadata(index)
	selected_spell.sigil_id = sigil_button.get_item_id(index)


func _on_turn_count_button_item_selected(index : int) -> void:
	# Temporary error,
	# should be moved to UI display
	if selected_spell == null:
		push_error("No spell selected, can't edit spell.")
		return

	selected_spell.turn_count_id = turn_count_button.get_item_id(index)
	selected_spell.turn_count = selected_spell.turn_count_id


func _on_target_button_item_selected(index : int) -> void:
	# Temporary error,
	# should be moved to UI display
	if selected_spell == null:
		push_error("No spell selected, can't edit spell.")
		return

	selected_spell.spell_target = index as Spell.SpellTarget
	selected_spell.target_id = target_button.get_item_id(index)


func _on_add_inner_ring_button_pressed() -> void:
	if current_ring != inner_spells:
		current_ring = inner_spells

	_add_spell()


func _on_delete_inner_ring_button_pressed() -> void:
	for spell : Spell in inner_spells.spells:
		inner_spells.spells.erase(spell)
		spell.queue_free()
	connections.redraw()
