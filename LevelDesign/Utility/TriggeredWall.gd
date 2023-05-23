extends Node2D

@onready var wall_to_be_destroyed = $WallToBeDestroyed
@onready var trigger = $Triggers/Trigger



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		wall_to_be_destroyed.queue_free()
		trigger.queue_free()
	pass # Replace with function body.
