extends Resource
class_name ItemResource

@export var id: StringName = ""
@export var name: String = ""
@export_multiline var description: String = ""
@export var stackable: bool = false
@export var is_consumable: bool = false
@export var is_destructible: bool = false
@export var texture: AtlasTexture
@export var modifiers: ModifierResource

# Inherited Method Child Class must implement
func use(target) -> void:
	print('Implement Me!')


# Inherited Method Child Class must implement
func on_collide(body: Node2D) -> void:
	print('Implement Me!')
