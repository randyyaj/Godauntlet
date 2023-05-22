extends Node2D

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	pass # Replace with function body.


func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		area.get_parent().speed = 0
		area.get_parent().stun_timer.start()
		timer.start()
	pass # Replace with function body.


func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.
