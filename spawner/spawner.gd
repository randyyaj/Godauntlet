extends Node2D

signal sig_death
signal sig_health_updated
signal sig_subtract_health

@export var enemy_spawn: PackedScene 
@export var health: int = 3
@export var spawn_rate: int = 5 #seconds
@export var texture: AtlasTexture

@onready var sprite_2d = $Sprite2D
@onready var timer = $Timer
@onready var collision_shape_2d = $CollisionShape2D

func connect_signals():
	sig_subtract_health.connect(subtract_health)


func _ready() -> void:
	connect_signals()
	sprite_2d.texture = texture
	collision_shape_2d.shape = RectangleShape2D.new()
	collision_shape_2d.shape.size = sprite_2d.get_rect().size
	timer.wait_time = spawn_rate
	timer.start()


func _on_timer_timeout():
	var new_enemy = enemy_spawn.instantiate()
	new_enemy.global_position = global_position
	get_tree().get_root().add_child(new_enemy)


func subtract_health(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()
	sig_health_updated.emit(health)


func die() -> void:
	sig_death.emit()
	queue_free()
