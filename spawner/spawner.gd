class_name Spawner
extends StaticBody2D

signal sig_death
signal sig_health_updated

@export var enemy_spawn: PackedScene 
@export var health: int = 3 :
	get:
		return health
	set(value):
		health = value
		# Level Scale Spawn Rate
		sprite_2d.self_modulate.a -= 0.25
		spawn_rate -= 0.25
		timer.wait_time = spawn_rate
		sig_health_updated.emit(health)
		if (health <= 0):
			die()

@export var spawn_rate: float = 1.5 #seconds
@export var texture: AtlasTexture
@export var score: int = 10

@onready var sprite_2d = $Sprite2D
@onready var timer = $SpawnTimer
@onready var collision_shape_2d = $CollisionShape2D


func _ready() -> void:
	sprite_2d.texture = texture
	collision_shape_2d.shape = RectangleShape2D.new()
	collision_shape_2d.shape.size = sprite_2d.get_rect().size
	timer.wait_time = spawn_rate


func die() -> void:
	sig_death.emit()
	PlayerManager.player.score = score
	queue_free()


func spawn() -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	if (enemies.size() < Global.MAX_ENEMIES_ON_SCREEN and enemy_spawn.can_instantiate()):
		var new_enemy = enemy_spawn.instantiate()
		new_enemy.level = health # scale the enemy's level according to spawner health
		new_enemy.global_position = global_position
		get_tree().get_root().add_child(new_enemy)


func _on_timer_timeout():
	spawn();


func _on_spawn_radius_body_entered(body: Node2D) -> void:
	timer.start()


func _on_spawn_radius_body_exited(body: Node2D) -> void:
	timer.stop()
