extends Node2D

@onready var timer = $Timer
@onready var area_2d = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D

var damage = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		area.get_parent().health -= damage # Inflict damage to player
		area_2d.set_deferred("monitoring", false)
		timer.start()
	pass # Replace with function body.


func _on_timer_timeout():
	area_2d.set_deferred("monitoring", true)
	pass # Replace with function body.
