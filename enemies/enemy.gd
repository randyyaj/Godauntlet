class_name Enemy
extends CharacterBody2D

signal sig_death
signal sig_health_updated
signal on_attack_area_body_entered
signal on_attack_timer_timeout
signal on_projectile_hit

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
@export var projectile: PackedScene
@export var fire_rate : float = .25
@export var shot_power := 25
@export var shot_speed := 100
@export var shooting_delay: float = 1.0
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

@export var is_ranged: bool = false
@export var is_projectile_bouncy: bool = false
@export var is_projectile_piercing: bool = false
@export var is_kamikaze := false
@export var is_melee_proof := false
@export var is_bullet_proof := false

@onready var navigation_agent_2d = $NavigationAgent2D
@onready var sprite_2d: Sprite2D = $Sprite2D

const MAX_PROJECTILE_DISTANCE = 200
var level := 3 :
	get:
		return level
	set(value):
		level = value
		health = spawner_level_scale[value].health
		power = spawner_level_scale[value].power
		score = spawner_level_scale[value].score

var is_attacking := false
var knockback_vector: Vector2 = Vector2.ZERO
var attack_area: Area2D = Area2D.new()
var attack_area_collision: CollisionShape2D = CollisionShape2D.new()
var attack_timer: Timer = Timer.new()
var shoot_timer: Timer = Timer.new()
var is_shooting := false

func connect_signals():
	attack_area.area_entered.connect(_on_area_2d_area_entered)
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	shoot_timer.timeout.connect(_on_timer_timeout)
	on_projectile_hit.connect(_on_projectile_hit)


func _ready():
	add_to_group('enemies', true)
	add_child(attack_timer)
	add_child(shoot_timer)
	add_child(attack_area)
	connect_signals()
	sprite_2d.self_modulate.a = spawner_level_scale[level].opacity
	attack_area_collision.shape = CircleShape2D.new()
	attack_area.monitoring = true
	attack_area.monitorable = true
	
	# Calculate scaled rect of sprite if scale is applied
	var scaled_width = sprite_2d.get_rect().size.x * sprite_2d.scale.x
	var scaled_height = sprite_2d.get_rect().size.y * sprite_2d.scale.y
	var scaled_rect = Rect2(sprite_2d.position, Vector2(scaled_width, scaled_height))

	# Add attack area and collision to scene
	attack_area_collision.shape.radius = scaled_rect.size.length() / 2.0
	attack_area.set_collision_layer_value(1, false) # BG Layer
	attack_area.set_collision_layer_value(4, true)  # Enemy Layer
	attack_area.set_collision_mask_value(2, true)   # Player Mask
	attack_area.set_collision_mask_value(4, false)  # Enemy Mask
	attack_area.set_collision_mask_value(6, false)  # Spawner Mask
	attack_area.add_child(attack_area_collision)
	
	if (is_ranged):
		shoot_timer.wait_time = shooting_delay
		shoot_timer.start()


func _physics_process(delta: float) -> void:
	if (is_instance_valid(PlayerManager.player)):
		navigation_agent_2d.set_target_position(PlayerManager.player.get_global_position())
		
	if (navigation_agent_2d.get_next_path_position()):
		velocity = (navigation_agent_2d.get_next_path_position() - global_position).normalized() * speed * delta
		velocity += knockback_vector
	
	if (is_shooting):
		velocity = Vector2.ZERO
		
	var collision = move_and_collide(velocity)
	knockback_vector = Vector2.ZERO


func shoot() -> void:
	if (is_instance_valid(PlayerManager.player)):
		is_shooting = true
		var distance_to_target = global_position.distance_to(PlayerManager.player.get_global_position())
		if (distance_to_target < MAX_PROJECTILE_DISTANCE):
			var bullet = projectile.instantiate()
			bullet.speed = shot_speed
			bullet.power = shot_power
			bullet.is_bouncy = is_projectile_bouncy
			bullet.is_piercing = is_projectile_piercing
			bullet.global_position = global_position
			bullet.look_at(PlayerManager.player.get_global_position())
			bullet.direction = (PlayerManager.player.get_global_position() - global_position).normalized()
			bullet.set_collision_mask_value(2, true)  # Player Mask
			bullet.set_collision_mask_value(4, false) # Enemy Mask
			bullet.set_collision_mask_value(6, false) # Spawner Mask
			get_tree().get_root().add_child(bullet)
			await get_tree().create_timer(.5).timeout
			is_shooting = false


func knockback(from_position, strength: int = 1) -> void:
	knockback_vector = (global_position - from_position).normalized() * strength


func set_target_position(position: Vector2):
	navigation_agent_2d.set_target_position(position)


func _on_projectile_hit(projectile: Projectile, knockback_strength: float) -> void:
	if (!is_bullet_proof):
		knockback(projectile.global_position, knockback_strength)
		health -= projectile.power


func die() -> void:
	sig_death.emit()
	PlayerManager.player.score += score
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		area.get_parent().emit_signal('on_melee_hit', power) # Inflict damage to player
		if (is_kamikaze):
			die()
		else:
			attack_area.set_deferred("monitoring", false)
			attack_timer.start()


func _on_attack_timer_timeout() -> void:
	attack_area.set_deferred("monitoring", true)


func _on_timer_timeout():
	shoot()
