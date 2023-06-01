extends Node2D

@export var spawner_list : Randomizer
@onready var potential_positions = $PotentialPositions

# Called when the node enters the scene tree for the first time.
func _ready(): 
	var spawn_points = randi_range(1,potential_positions.get_child_count()) #get spawn points
	spawner_list.randomList.shuffle()
	var spawner = spawner_list.randomList[0].instantiate()
	add_child(spawner)
	spawner.global_position = potential_positions.get_child(spawn_points - 1).global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
