extends Node2D

@export var health = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		queue_free()
	pass


func _on_area_2d_area_entered(area):
	pass # Replace with function body.
