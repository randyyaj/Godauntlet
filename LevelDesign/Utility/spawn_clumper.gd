extends Node2D

@export var enemy_type : PackedScene
@export var enemy_count : int
@onready var spawn_pos = $SpawnPos

# Called when the node enters the scene tree for the first time.
func _ready():
	for enemy in enemy_count:
		var enemy_inst = enemy_type.instantiate()
		add_child(enemy_inst)
		enemy_inst.position = spawn_pos.global_position + Vector2(randi_range(-5,5),randi_range(-5,5))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
