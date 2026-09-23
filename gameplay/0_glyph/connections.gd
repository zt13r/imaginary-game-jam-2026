class_name Connections
extends Control


@export var outer_ring : RingContainer = null
@export var inner_ring : RingContainer = null

@export var line_width : float = 4.0
@export var line_color : Color = Color.WHITE


func _draw() -> void:
	if outer_ring == null or inner_ring == null:
		push_error("A RingContainer reference is null, can't draw connections.")
		return

	for ring : RingContainer in [outer_ring, inner_ring]:
		for spell : Spell in ring.spells:
			if spell.frame == null:
				push_error(name + " Frame is null.")
				return
			if spell.previous_spell == null:
				push_error(name + " PreviousSpell is null.")
				return
			if spell.then_spell == null:
				push_error(name + " ThenSpell is null.")
				return

			# Convert to local pozetion da global pozetion
			# Why I say it like that/

			var spell_pos : Vector2 =\
				to_local(spell.global_position)

			var then_spell_pos : Vector2 =\
				to_local(spell.then_spell.global_position)

			if spell.frame.type == Frame.Type.EXECUTION:
				draw_line(
					spell_pos, then_spell_pos, line_color, line_width
				)


func redraw() -> void:
	queue_redraw.call_deferred()


func to_local(global : Vector2) -> Vector2:
	return get_global_transform().affine_inverse() * global
