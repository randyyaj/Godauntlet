extends Node2D

@onready var timer = $Timer

@export var slow_factor := .5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		var OGspeed = area.get_parent().speed
		area.get_parent().speed = OGspeed * slow_factor
		print(str(OGspeed))
	pass # Replace with function body.


func _on_area_2d_area_exited(area):
	if area.is_in_group("Player"):
		var OGspeed = area.get_parent().default_speed
		area.get_parent().speed = OGspeed
	pass # Replace with function body.
