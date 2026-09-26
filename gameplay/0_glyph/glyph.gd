class_name MagicGlyph
extends Control


signal spell_selected(spell : Spell)


const SPELL_SCENE : PackedScene = preload("uid://bn0pur841hkr6")

const SIGIL_RESOURCES : Array[Sigil] = [
	preload("uid://0k4l5lbx5apa"), # Fire
]


@export var main_game : MainGame = null
@export var puzzle : Puzzle = null :
	get:
		if not puzzle:
			if get_parent() is Puzzle:
				puzzle = get_parent()
			else:
				push_error("Glyph parent is not Puzzle.")
		return puzzle
@export var turn_count_menu : OptionButton = null


var current_ring : RingContainer = null :
	get:
		if not current_ring:
			current_ring = outer_spells
		return current_ring
var selected_spell : Spell = null


@onready var connections : Connections = %Connections

@onready var outer_spells : RingContainer = %OuterSpells


func _ready() -> void:
	_init_spell_stuff()
	_assign_initial_spell_connections()

	var first_spell : Spell = current_ring.spells.front()
	first_spell.spell_selected.emit(first_spell)

	connections.redraw()


func _init_spell_stuff() -> void:
	# Append spells to respective ring arrays and connect signals
	for spell : Spell in outer_spells.get_children():
		outer_spells.spells.append(spell)
		spell.spell_selected.connect(_on_spell_selected)


func _assign_initial_spell_connections() -> void:
	# Get each spell's previous spell's then spells (???)
	for spell : Spell in outer_spells.spells:
		spell.get_previous_spell_then_spell(outer_spells.spells)


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
		selected_spell.then_spell.previous_spell = selected_spell.previous_spell

		selected_spell.queue_free()
		selected_spell = null

	await get_tree().process_frame
	connections.redraw()


func _on_spell_selected(spell : Spell) -> void:
	if selected_spell != null:
		if selected_spell != spell:
			# Debug, reset color of selected spell
			selected_spell.then_spell.modulate = Color.WHITE
			selected_spell.modulate = Color.WHITE

			if spell.sigil != null:
				spell_selected.emit(spell)

	if spell.get_parent() is RingContainer:
		current_ring = spell.get_parent()
	else:
		push_error("Selected spell's parent is somehow NOT a RingContainer.")

	selected_spell = spell

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

	if puzzle == null:
		push_error("Puzzle is null")
		return

	await main_game.cast()

	await get_tree().create_timer(2.0).timeout

	# Debug, reset colors before casting
	# Because there is also coloring during casting idk
	# What
	for spell : Spell in outer_spells.spells:
		spell.modulate = Color.WHITE

	Game.target.clear_effects()

	var turns : int = 1
	var spells : Array[Spell] = outer_spells.spells.duplicate()

	while turns <= outer_spells.spells.size():
		var next_spell : Spell = spells.pop_front()
		next_spell.cast()

		# Debug
		next_spell.modulate = Color.PURPLE

		await get_tree().create_timer(
			MainGame.seconds_turn_increment).timeout
		Game.target.end_turn()

		# Debug also, probably
		next_spell.modulate = Color.WHITE

		turns += 1

	var satisfied : bool = false

	main_game.done_cast()

	for rule : Rule in puzzle.current_level.rules:
		if rule is OnlyRule:
			if rule.is_satisfied(Game.target, puzzle.current_level.goal_effects):
				satisfied = true
				continue
			else:
				push_error("OnlyRule not satisifed")
		elif rule is BannedRule:
			if not rule.is_satisfied(current_ring.spells):
				satisfied = true
				continue
			else:
				push_error("BannedRule not satisifed")
		elif rule is SpellCountRule:
			if not rule.is_satisfied(current_ring.spells.size()):
				satisfied = true
				continue
			else:
				push_error("SpellCountRule not satisifed")

	print("GOAL EFFECTS: ")
	for goal_effect : Effect in puzzle.current_level.goal_effects:
		print("%s, " % goal_effect.name)
		if Game.target.has_effect(goal_effect):
			satisfied = true
		else:
			satisfied = false
			break
	print("TARGET EFFECTS: ", Game.target.format_effects(Game.target.effects))

	if satisfied:
		print("YAY YOU BEAT THE LEVEL")
		puzzle.next_level()
	else:
		print("You no beat level :(")


func _on_sigil_selected(sigil : Sigil) -> void:
	# Temporary error,
	# should be moved to UI display
	if selected_spell == null:
		push_error("No spell selected, can't edit sigil.")
		return

	selected_spell.sigil = sigil

	if selected_spell.turn_count == -1:
		selected_spell.turn_count = 1


func _on_turn_count_menu_item_selected(index : int) -> void:
	# Temporary errors,
	# should be moved to UI display
	if selected_spell == null:
		push_error("No spell selected, can't edit turn count.")
		return
	if turn_count_menu == null:
		push_error("No turn count menu reference, can't edit turn count.")
		return

	selected_spell.turn_count = turn_count_menu.get_item_id(index) + 1
