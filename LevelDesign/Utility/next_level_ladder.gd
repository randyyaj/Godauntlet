extends Node2D

@onready var area_2d = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		LevelTransition.emit_signal("level_beat")
		area_2d.queue_free()
		get_parent().queue_free()
	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	pass # Replace with function body.
