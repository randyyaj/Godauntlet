class_name Sorcerer
extends Enemy

@export var invisibility_duration: float = 1

@onready var invisibility_timer: Timer = $InvisibilityTimer
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	super()
	invisibility_timer.wait_time = invisibility_duration #randf_range(1, 3)

func _on_invisibility_timer_timeout() -> void:
	is_melee_proof = !is_melee_proof
	is_bullet_proof = !is_bullet_proof
	var tween: Tween = get_tree().create_tween()
	
	if (is_bullet_proof):
		tween.tween_property($Sprite2D, "modulate", Color(0, 0, 0, 0), 1).set_trans(Tween.TRANS_SINE)
		set_collision_mask_value(7, false) # Projectile Mask
	else:
		tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1, 1), 1).set_trans(Tween.TRANS_SINE)
		set_collision_mask_value(7, true) # Projectile Mask


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is Projectile and is_bullet_proof):
		body.set_collision_mask_value(4, false)
	else:
		body.set_collision_mask_value(4, true)
