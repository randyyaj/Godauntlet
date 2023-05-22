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
@export var score := 100
@export var speed: int = 50
@export var is_ranged: bool = false

@export var projectile: PackedScene
@export var fire_rate : float = .25
@export var shot_power := 25
@export var shot_speed := 100
@export var shooting_delay := 1

@onready var navigation_agent_2d = $NavigationAgent2D
@onready var timer = $Timer

var is_attacking := false


func _ready():
	add_to_group('enemies', true)
	timer.wait_time = shooting_delay
	timer.start()
	

func _physics_process(delta: float) -> void:
	navigation_agent_2d.set_target_position(PlayerManager.player.get_global_position())
	velocity = (navigation_agent_2d.get_next_path_position() - global_position).normalized() * speed * delta
	var collision = move_and_collide(velocity)
	if (collision and not is_attacking):
		var body = collision.get_collider()
		if (body == PlayerManager.player):
			is_attacking = true
			await get_tree().create_timer(1).timeout
			# todo play attack animation
			body.health -= power # Inflict power to player
			is_attacking = false
			

func shoot() -> void:
	var distanceToTarget = global_position.distance_to(PlayerManager.player.get_global_position())
	if (is_ranged):
		var bullet = projectile.instantiate()
		bullet.speed = shot_speed
		bullet.power = shot_power
		bullet.global_position = global_position
		bullet.look_at(PlayerManager.player.get_global_position())
		bullet.direction = (PlayerManager.player.get_global_position() - global_position).normalized()
		bullet.set_collision_mask_value(2, true)  # Player Mask
		bullet.set_collision_mask_value(4, false) # Enemy Mask
		bullet.set_collision_mask_value(6, false) # Spawner Mask
		get_tree().get_root().add_child(bullet)


func die() -> void:
	sig_death.emit()
	PlayerManager.player.score = score
	queue_free()


func _on_timer_timeout():
	shoot()
