extends Resource
class_name ItemResource

@export var id: StringName = ""
@export var name: String = ""
@export_multiline var description: String = ""
@export var stackable: bool = false
@export var is_consumable: bool = false
@export var is_destructible: bool = false
@export var texture: AtlasTexture
@export var modifiers: Array[Modifier]

func apply_modifiers(body: PhysicsBody2D) -> void:
	for modifier in modifiers:
		modifier.apply(body)
