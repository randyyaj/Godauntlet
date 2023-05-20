extends Node2D
class_name Treasure

signal sig_item_collided(body: Node2D)

@export var data: ItemResource
@onready var area_2d: Area2D = $Area2D


## Connect all signals here
func connect_signals() -> void:
	sig_item_collided.connect(apply_modifier) 


func _ready() -> void:
	connect_signals()


func apply_modifier(body: Node2D) -> Node2D:
	body.sig_add_score.emit(1000)
	return body


func _on_area_2d_body_entered(body: Node2D) -> void:
	emit_signal('sig_item_collided', body)
	queue_free()
