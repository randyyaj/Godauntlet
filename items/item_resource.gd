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

func apply_modifier(body: PhysicsBody2D) -> void:
	if (body.data and body.data is ModifierResource):
		if (modifiers.health):
			body.sig_add_health.emit(modifiers.health)
		if (modifiers.speed):
			body.sig_add_speed.emit(modifiers.speed)
		if (modifiers.damage):
			body.sig_add_damage.emit(modifiers.damage)
		if (modifiers.defense):
			body.sig_add_defense.emit(modifiers.defense)
		if (modifiers.magic):
			body.sig_add_magic.emit(modifiers.magic)
		if (modifiers.shot_power):
			body.sig_add_shot_power.emit(modifiers.shot_power)
		if (modifiers.shot_speed):
			body.sig_add_shot_speed.emit(modifiers.shot_speed)
		if (modifiers.score):
			body.sig_add_score.emit(modifiers.score)
