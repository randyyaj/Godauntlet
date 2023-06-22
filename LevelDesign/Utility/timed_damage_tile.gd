extends Node2D

@onready var timer = $Timer
@onready var area_2d = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var spike_up_t_imer = $SpikeUpTImer
@onready var spike_down_tex = $SpikeDown

var spikes_up = false
@export var damage_frequency = .2
@export var damage = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = damage_frequency
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		area_2d.set_deferred("monitoring", false)
		area.get_parent().health -= damage # Inflict damage to player
		timer.start()


func _on_timer_timeout():
		area_2d.set_deferred("monitoring", true)
	#area_2d.set_deferred("monitoring", true)


func _on_spike_up_t_imer_timeout():
	if not spikes_up:
		spikes_up = true
		spike_down_tex.visible = true
		area_2d.set_deferred("monitoring", false)
	else:
		area_2d.set_deferred("monitoring", true)
		spike_down_tex.visible = false
		spikes_up = false
