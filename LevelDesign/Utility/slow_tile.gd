extends Node2D

var damage := 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		area.get_parent().speed = area.get_parent().speed / 2
	pass # Replace with function body.


func _on_area_2d_area_exited(area):
	if area.is_in_group("Player"):
		area.get_parent().speed = area.get_parent().speed * 2
	pass # Replace with function body.
