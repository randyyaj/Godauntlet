class_name WalkState
extends BaseState

#var animation_state_machine = animation_tree["parameters/playback"]
var direction: Vector2


func _ready():
	state_name = 'WALK'

func on_enter(_msg := {}) -> void:
	animation_tree['parameters/conditions/is_moving'] = true

func state_physics_process(delta: float) -> void:
	direction = Input.get_vector("control_left", "control_right", "control_up", "control_down")

	if (direction != Vector2.ZERO):
		character.velocity = character.velocity.move_toward(direction.normalized() * character.speed, 20)
		animation_tree.set("parameters/Walk/blend_position", direction)
		character.move_and_slide()
	else:
		state_machine.change_state(state_machine.get_state('IDLE'))


func on_exit() -> void:
	animation_tree['parameters/conditions/is_moving'] = false
