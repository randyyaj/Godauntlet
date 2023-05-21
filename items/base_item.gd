extends Node
class_name BaseItem

signal sig_item_collided(body: Node2D)

@export var data: ItemResource

var sprite2D: Sprite2D = Sprite2D.new()
var area2D: Area2D = Area2D.new()
var collisionShape: CollisionShape2D = CollisionShape2D.new()

## Connect all signals here
func connect_signals() -> void:
	sig_item_collided.connect(apply_modifiers) 
	area2D.body_entered.connect(_on_area_2d_body_entered)


func _ready() -> void:
	connect_signals()
	if (data and data.texture):
		sprite2D.texture = data.texture
		collisionShape.shape = RectangleShape2D.new()
		collisionShape.shape.size = sprite2D.get_rect().size
		area2D.set_collision_layer_value(5, true) # Items Layer
		area2D.set_collision_mask_value(2, true)  # Player Mask
		area2D.add_child(collisionShape)
		add_child(sprite2D)
		add_child(area2D)
	
	
func apply_modifiers(body: PhysicsBody2D) -> Node2D:
	data.apply_modifiers(body)
	return body


func _on_area_2d_body_entered(body: Node2D) -> void:
	emit_signal('sig_item_collided', body)
	queue_free()
