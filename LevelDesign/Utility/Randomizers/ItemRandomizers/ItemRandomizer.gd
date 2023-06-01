extends Node2D

@export var item_list : Array[Randomizer]
@onready var potential_positions = $PotentialPositions

@export var spawn_chance : float = .85 #spawn chance

# Called when the node enters the scene tree for the first time.
func _ready():
	var spawn_checker = randi_range(0,100)
	print(spawn_checker)
	var spawn_barrier = 100 * spawn_chance #convert spawn chance to int
	
	if spawn_checker < spawn_barrier:
		item_list[0].randomList.shuffle()
		var itemInst = item_list[0].randomList[0].instantiate()
		add_child(itemInst)
		itemInst.position = potential_positions.get_child(randi_range(0,potential_positions.get_child_count() - 1)).global_position
		pass # Replace with function body.
	else:
		return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
