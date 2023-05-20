extends Node
class_name Key

signal sig_item_collided(body: Node2D)

@export var data: ItemResource
@export var duration: int = 0
@export var modifier_amount: int = 0
@export var texture: AtlasTexture

var sprite2D: Sprite2D = Sprite2D.new()
var area2D: Area2D = Area2D.new()
var collisionShape: CollisionShape2D = CollisionShape2D.new()

## Connect all signals here
func connect_signals() -> void:
	area2D.body_entered.connect(_on_area_2d_body_entered)


func _ready() -> void:
	connect_signals()
	sprite2D.texture = texture
	collisionShape.shape = RectangleShape2D.new()
	collisionShape.shape.size = sprite2D.get_rect().size
	area2D.add_child(collisionShape)
	add_child(sprite2D)
	add_child(area2D)


func _on_area_2d_body_entered(body: Node2D) -> void:
	emit_signal('sig_item_collided', body)
	body.sig_add_key.emit(1)
	queue_free()
