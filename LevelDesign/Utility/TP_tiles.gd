extends Node2D

@onready var tile_1_position = $Tile1/Tile1Position
@onready var tile_2_position = $Tile2/Tile2Position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tile_1_area_area_entered(area):
	if area.is_in_group("Player"):
		area.get_parent().position = tile_2_position.global_position
	#area.get_parent().position = tile_1_position.position
	pass # Replace with function body.


func _on_tile_2_area_area_entered(area):
	if area.is_in_group("Player"):
		area.get_parent().position = tile_1_position.global_position
	pass # Replace with function body.


func _on_tile_1_area_body_entered(body):
	pass # Replace with function body.
