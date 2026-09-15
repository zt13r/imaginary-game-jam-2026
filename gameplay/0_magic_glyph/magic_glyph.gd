class_name MagicGlyph
extends Control


const SPELL_SCENE : PackedScene = preload("uid://bn0pur841hkr6")


var selected_spell : Spell = null


@onready var spell_container : SpellContainer = $Spells


func _ready() -> void:
	for spell : Spell in spell_container.get_children():
		spell.spell_selected.connect(_on_spell_selected)


func _add_spell() -> void:
	if spell_container.spells.size() >= spell_container.max_spell_count:
		return

	var spell : Spell = SPELL_SCENE.instantiate() as Spell
	spell.spell_selected.connect(_on_spell_selected)
	spell_container.add_child(spell)


func _delete_selected_spell() -> void:
	if is_instance_valid(selected_spell):
		spell_container.spells.erase(selected_spell)
		selected_spell.queue_free()
		selected_spell = null


func _on_spell_selected(spell : Spell) -> void:
	# Debug
	if selected_spell != spell and selected_spell != null:
		selected_spell.modulate = Color.WHITE

	selected_spell = spell

	# Debug
	selected_spell.modulate = Color.GOLD


func _on_add_spell_button_pressed() -> void:
	_add_spell()


func _on_delete_selected_spell_button_button_up() -> void:
	_delete_selected_spell()
