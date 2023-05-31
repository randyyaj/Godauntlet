class_name HurtState
extends BaseState


func _ready():
	state_name = 'HURT'
	

func on_enter(_msg := {}) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(character.sprite_2d, "modulate", Color(1, 0, 0, 1), .1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(character.sprite_2d, "modulate", Color(1, 1, 1, 1), .1).set_trans(Tween.TRANS_BOUNCE)
	next_state = state_machine.get_state('WALK')


func state_physics_process(delta: float) -> void:
	var direction = Input.get_vector("control_left", "control_right", "control_up", "control_down")

	if (direction != Vector2.ZERO):
		character.velocity = character.velocity.move_toward(direction.normalized() * character.speed, 20)
		animation_tree.set("parameters/Walk/blend_position", direction)
		character.move_and_slide()
	else:
		state_machine.change_state(state_machine.get_state('IDLE'))
