class_name StateMachine
extends Node

@export var character: CharacterBody2D
@export var previous_state: BaseState
@export var current_state: BaseState

@onready var idle: Node = $Idle
@onready var walk: Node = $Walk
@onready var shoot: Node = $Shoot
@onready var melee: Node = $Melee
@onready var hurt: Node = $Hurt

var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if (child is BaseState):
			child.character = character
			states[child.state_name] = child
		else:
			push_warning('Child ', child.name, ' is not type State')


func get_state(state_name: StringName) -> BaseState:
	if (states.has(state_name)):
		return states.get(state_name)
	else:
		return null


func _physics_process(delta: float) -> void:
	if (current_state and current_state.next_state != null):
		change_state(current_state.next_state)
	
	if (current_state):
		current_state.state_process(delta)


func change_state(new_state: BaseState):
	if (current_state != null):
		current_state.on_exit()
		current_state.next_state = null
		
	if (new_state):
		current_state = new_state
		if (current_state):
			current_state.on_enter()


func can_move():
	return current_state.can_move


func _input(event: InputEvent) -> void:
	if (current_state):
		current_state.state_input(event)
