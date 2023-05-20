extends Node
class_name Potion

enum POTION_TYPE {
	ARMOR,
	STRENGTH,
	MAGIC,
	SPEED,
}

signal sig_item_collided(body: Node2D)

@export var data: ItemResource
@export var potion_type: POTION_TYPE
@export var duration: int = 0
@export var modifier_amount: int = 0
@export var texture: AtlasTexture

#@onready var area_2d: Area2D = $Area2D
#@onready var sprite_2d = $Sprite2D

var sprite2D: Sprite2D = Sprite2D.new()
var area2D: Area2D = Area2D.new()
var collisionShape: CollisionShape2D = CollisionShape2D.new()

## Connect all signals here
func connect_signals() -> void:
	sig_item_collided.connect(apply_modifier) 
	area2D.body_entered.connect(_on_area_2d_body_entered)


func _ready() -> void:
	connect_signals()
	sprite2D.texture = texture
	collisionShape.shape = RectangleShape2D.new()
	collisionShape.shape.size = sprite2D.get_rect().size
	area2D.add_child(collisionShape)
	add_child(sprite2D)
	add_child(area2D)


func apply_modifier(body: Node2D) -> Node2D:
	match potion_type:
		POTION_TYPE.ARMOR:
			body.sig_set_defense.emit(modifier_amount)
		POTION_TYPE.STRENGTH:
			body.sig_set_damage.emit(modifier_amount)
		POTION_TYPE.MAGIC:
			body.sig_set_magic.emit(modifier_amount)
		POTION_TYPE.SPEED:
			body.sig_set_speed.emit(modifier_amount)
		"_":
			pass
			
	body.sig_add_health.emit(1000)
	return body


func _on_area_2d_body_entered(body: Node2D) -> void:
	emit_signal('sig_item_collided', body)
	queue_free()
