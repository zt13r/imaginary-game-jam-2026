class_name Connections
extends Control


@export var outer_ring : RingContainer = null
@export var inner_ring : RingContainer = null

@export var line_width : float = 4.0


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

			var prev_spell_pos : Vector2 =\
				get_global_transform().affine_inverse() *\
				spell.previous_spell.global_position

			var then_spell_pos : Vector2 =\
				get_global_transform().affine_inverse() *\
				spell.then_spell.global_position

			if spell.frame.type == Frame.Type.EXECUTION:
				draw_line(
					prev_spell_pos, then_spell_pos, Color.WHITE, 4.0
				)

			elif spell.frame.type == Frame.Type.DECISION:
				if spell.else_spell == null:
					push_error(name + " ElseSpell is null.")
					return
				var else_spell_pos : Vector2 = spell.else_spell.global_position

				draw_line(
					prev_spell_pos, then_spell_pos, Color.WHITE, 4.0
				)

				draw_line(
					prev_spell_pos, else_spell_pos, Color.WHITE, 4.0
				)
