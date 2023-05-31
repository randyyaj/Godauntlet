class_name Lobber
extends Enemy


@onready var runaway_area_2d: Area2D = $RunawayArea2D

var is_running_away := false

func _physics_process(delta: float) -> void:
	if (navigation_agent_2d.get_next_path_position()):
		velocity = (navigation_agent_2d.get_next_path_position() - global_position).normalized() * speed * delta
		velocity += knockback_vector
	
	if (is_shooting):
		velocity = Vector2.ZERO
		
	var collision = move_and_collide(velocity)
	knockback_vector = Vector2.ZERO
	
	if (is_running_away):
		var direction = global_position - global_position.direction_to(PlayerManager.player.get_global_position())
		navigation_agent_2d.set_target_position(direction)
	else:
		if (is_instance_valid(PlayerManager.player)):
			navigation_agent_2d.set_target_position(PlayerManager.player.get_global_position())


func _on_runaway_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		is_running_away = true


func _on_runaway_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		is_running_away = false
		
