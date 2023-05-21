class_name Enemy
extends CharacterBody2D

signal sig_death
signal sig_add_health
signal sig_health_updated
signal sig_subtract_health

@export var max_health := 3
@export var health := 3
@export var damage := 10
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

## Connect signals to functions within script
func _connect_signals():
	sig_add_health.connect(add_health) 
	sig_subtract_health.connect(subtract_health)


func _ready():
	_connect_signals()
	add_to_group('enemies', true)
	timer.wait_time = shooting_delay
	timer.start()
	

func _physics_process(delta: float) -> void:
	navigation_agent_2d.set_target_position(PlayerManager.player.get_global_position())
	velocity = (navigation_agent_2d.get_next_path_position() - global_position).normalized() * speed * delta
	var collision = move_and_collide(velocity)
	if (collision):
		var body = collision.get_collider()
		if (body == PlayerManager.player):
			body.sig_subtract_health.emit(damage) # Inflict damage to player


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
	PlayerManager.player.sig_add_score.emit(score)
	queue_free()


func _on_timer_timeout():
	shoot()
