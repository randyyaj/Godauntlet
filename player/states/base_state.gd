class_name BaseState
extends Node

@export var state_name: StringName
@export var animation_tree: AnimationTree
@export var animation_player: AnimationPlayer
@export var sfx: AudioStream
@export var can_move: bool = true
@export var can_attack: bool = true
@export var next_state: BaseState
@export var state_machine: StateMachine

var character: CharacterBody2D

func _ready():
	if (owner is StateMachine):
		state_machine = owner


func on_enter(_msg := {}) -> void:
	pass


func on_exit() -> void:
	pass


func state_input(event: InputEvent) -> void:
	pass
#	if (event):
#		print('state_machine ', state_machine)


func state_process(delta: float) -> void:
	pass


func state_physics_process(delta: float) -> void:
	pass
