extends Node
class_name Potion

enum POTION_TYPE {
	ARMOR,
	SPEED,
	MAGIC,
	SHOT_POWER,
	SHOT_SPEED,
	FIGHT_POWER,
	BOMB
}

signal sig_item_collided(body: Node2D)

@export var data: ItemResource
@export var potion_type: POTION_TYPE
@export var duration: int = 0
@export var modifier_amount: int = 0

@onready var area_2d: Area2D = $Area2D


## Connect all signals here
func connect_signals() -> void:
	sig_item_collided.connect(apply_modifier) 


func _ready() -> void:
	connect_signals()


func apply_modifier(body: Node2D) -> Node2D:
	match potion_type:
		POTION_TYPE.ARMOR:
			body.sig_set_defense.emit(modifier_amount)
		POTION_TYPE.SPEED:
			body.sig_set_speed.emit(modifier_amount)
		POTION_TYPE.MAGIC:
			body.sig_set_magic.emit(modifier_amount)
		POTION_TYPE.SHOT_POWER:
			body.sig_set_projectile_damage.emit(modifier_amount)
		POTION_TYPE.SHOT_SPEED:
			body.sig_set_projectile_speed.emit(modifier_amount)
		POTION_TYPE.FIGHT_POWER:
			body.sig_set_damage.emit(modifier_amount)
		POTION_TYPE.BOMB:
			body.sig_add_bomb.emit(modifier_amount)
		"_":
			pass
			
	body.sig_add_health.emit(1000)
	return body


func _on_area_2d_body_entered(body: Node2D) -> void:
	emit_signal('sig_item_collided', body)
	queue_free()


func _on_timer_timeout() -> void:
	pass # Replace with function body.
