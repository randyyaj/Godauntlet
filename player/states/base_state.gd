class_name BaseState
extends Node

@export var state_name: StringName
@export var animation_tree: AnimationTree
@export var animation_player: AnimationPlayer
@export var audio_player: AudioStreamPlayer
@export var sfx: AudioStream
@export var can_move: bool = true
@export var can_attack: bool = true
@export var next_state: BaseState
@export var state_machine: StateMachine

var character: CharacterBody2D

func _ready():
	if (owner is StateMachine):
		state_machine = owner
	if (!audio_player):
		audio_player = AudioStreamPlayer.new()
		add_child(audio_player)


func on_enter(_msg := {}) -> void:
	if (audio_player and sfx):
		audio_player.stream = sfx
		audio_player.play()


func on_exit() -> void:
	pass


func state_input(event: InputEvent) -> void:
	pass


func state_process(delta: float) -> void:
	pass


func state_physics_process(delta: float) -> void:
	pass
