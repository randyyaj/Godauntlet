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
		sig_health_updated.emit(health)
		if (health <= 0):
			die()

@export var spawn_rate: int = 5 #seconds
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
	timer.start()


func _on_timer_timeout():
	var new_enemy = enemy_spawn.instantiate()
	new_enemy.global_position = global_position
	get_tree().get_root().add_child(new_enemy)


func die() -> void:
	sig_death.emit()
	PlayerManager.player.score += score
	queue_free()
