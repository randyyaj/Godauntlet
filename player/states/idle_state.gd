class_name IdleState
extends BaseState

func _ready():
	state_name = 'IDLE'


func on_enter(_msg := {}) -> void:
	animation_tree['parameters/conditions/is_idle'] = true
	animation_tree.set("parameters/Idle/blend_position", character.last_facing_direction)


func on_exit() -> void:
	animation_tree['parameters/conditions/is_idle'] = false
