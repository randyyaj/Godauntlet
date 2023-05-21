class_name Enemy
extends CharacterBody2D

signal sig_death
signal sig_health_updated

@export var max_health := 3
@export var health := 3 :
	get:
		return health
	set(value):
		health = value
		sig_health_updated.emit(health)
		if (health <= 0):
			die()

@export var power := 10
@export var defense := 0
@export var score := 10
@export var speed: int = 50
@export var is_ranged: bool = false
@export var projectile: PackedScene
@export var fire_rate : float = .25
@export var shot_power := 25
@export var shot_speed := 100
@export var shooting_delay := 1
@export var spawner_level_scale: Dictionary = {
	1: {
		'health': 1,
		'power': 10,
		'score': 10,
		'opacity': .5
	},
	2: {
		'health': 2,
		'power': 20,
		'score': 10,
		'opacity': .75
	},
	3: {
		'health': 3,
		'power': 30,
		'score': 10,
		'opacity': 1
	}
}

@onready var navigation_agent_2d = $NavigationAgent2D
@onready var timer = $Timer
@onready var sprite_2d: Sprite2D = $Sprite2D

var is_attacking := false

var level := 3 :
	get:
		return level
	set(value):
		level = value
		health = spawner_level_scale[value].health
		power = spawner_level_scale[value].power
		score = spawner_level_scale[value].score
		


func _ready():
	add_to_group('enemies', true)
	timer.wait_time = shooting_delay
	timer.start()
	sprite_2d.self_modulate.a = spawner_level_scale[level].opacity

func _physics_process(delta: float) -> void:
	navigation_agent_2d.set_target_position(PlayerManager.player.get_global_position())
	velocity = (navigation_agent_2d.get_next_path_position() - global_position).normalized() * speed * delta
	var collision = move_and_collide(velocity)
	if (collision):
		var body = collision.get_collider()
		if (body == PlayerManager.player):
			is_attacking = true
			await get_tree().create_timer(1).timeout
			# todo play attack animation
			body.health -= power # Inflict power to player
			is_attacking = false


func add_health(amount: int) -> void:
	if (health < max_health):
		if (health + amount > max_health):
			health = max_health
		else:
			health += amount
		sig_health_updated.emit(health)


func subtract_health(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()
	sig_health_updated.emit(health)


func die() -> void:
	sig_death.emit()
	PlayerManager.player.score = score
	queue_free()


func _on_timer_timeout():
	shoot()
