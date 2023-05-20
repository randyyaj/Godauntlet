class_name Enemy
extends CharacterBody2D

signal sig_death

@export var health := 3
@export var damage := 1
@export var defense := 0
@export var score := 100
@export var speed: int = 50

@onready var navigation_agent_2d = $NavigationAgent2D

## Connect signals to functions within script
func _connect_signals():
	pass


func _ready():
	_connect_signals()
	add_to_group('enemies', true)
	

func _physics_process(delta: float) -> void:
	navigation_agent_2d.set_target_position(PlayerManager.player.get_global_position())
	velocity = (navigation_agent_2d.get_next_path_position() - global_position) * speed * delta
	move_and_slide()


func die() -> void:
	queue_free()
