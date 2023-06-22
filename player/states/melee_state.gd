class_name MeleeState
extends BaseState

var attack_direction = Vector2.DOWN

func _ready():
	state_name = 'MELEE'
	

func on_enter(_msg := {}) -> void:
	super()
	animation_tree['parameters/conditions/is_melee'] = true


func on_exit() -> void:
	animation_tree['parameters/conditions/is_melee'] = false


func state_physics_process(delta: float) -> void:
	var direction = Input.get_vector("control_left", "control_right", "control_up", "control_down")

	if (direction != Vector2.ZERO):
		character.velocity = character.velocity.move_toward(direction.normalized() * character.speed, 20)
		animation_tree.set("parameters/Melee/blend_position", direction)
		character.move_and_slide()
	else:
		state_machine.change_state(state_machine.get_state('IDLE'))
