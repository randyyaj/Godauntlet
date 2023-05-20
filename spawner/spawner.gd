extends Node2D

@export var enemy_spawn: PackedScene 
@export var spawn_rate: int = 5 #seconds
@export var texture: AtlasTexture

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var timer = $Timer

func connect_signals():
	pass

func _ready() -> void:
	connect_signals()
	sprite_2d.texture = texture
	collision_shape_2d.shape = RectangleShape2D.new()
	collision_shape_2d.shape.size = sprite_2d.get_rect().size


func _physics_process(delta) -> void:
	pass


func _on_timer_timeout():
	var new_enemy = enemy_spawn.instantiate()
	new_enemy.global_position = global_position
	get_tree().get_root().add_child(new_enemy)
