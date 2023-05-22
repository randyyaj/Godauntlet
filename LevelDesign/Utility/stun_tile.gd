extends Node2D

@export var stun_duration: float = 1

func _on_area_2d_body_entered(body):
	pass # Replace with function body.


func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		print('here')
		area.get_parent().speed = 0
		await get_tree().create_timer(stun_duration).timeout
		area.get_parent().speed = area.get_parent().default_speed
		queue_free()

	
