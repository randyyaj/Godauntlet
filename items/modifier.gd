class_name Modifier
extends Resource

enum ModifierType {
	HEALTH,
	SPEED,
	SHOT_SPEED,
	POWER,
	SHOT_POWER,
	MAGIC_POWER,
	DEFENSE,
	SCORE,
	BOMB,
	KEY
}

enum OperationType {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE,
	ASSIGN
}

@export var modifier_type: ModifierType
@export var amount: int = 0
@export var operation_type: OperationType
@export var duration: float = 0


func apply(body: PhysicsBody2D):
	if (body is Player): # Kind of unnecessary since we have collision layers but otherwise not a bad check
		match modifier_type:
			ModifierType.HEALTH:
				body.apply_modifier('health', get_operation(), amount, duration, body.sig_health_updated);
			ModifierType.SPEED:
				body.apply_modifier('speed', get_operation(), amount, duration, body.sig_speed_updated);
			ModifierType.SHOT_SPEED:
				body.apply_modifier('shot_speed', get_operation(), amount, duration, body.sig_shot_speed_updated);
			ModifierType.POWER:
				body.apply_modifier('power', get_operation(), amount, duration, body.sig_power_updated);
			ModifierType.SHOT_POWER:
				body.apply_modifier('shot_power', get_operation(), amount, duration, body.sig_shot_power_updated);
			ModifierType.MAGIC_POWER:
				body.apply_modifier('magic_power', get_operation(), amount, duration, body.sig_magic_power_updated);
			ModifierType.DEFENSE:
				body.apply_modifier('defense', get_operation(), amount, duration, body.sig_defense_updated);
			ModifierType.SCORE:
				body.apply_modifier('score', get_operation(), amount, duration, body.sig_score_updated);
			ModifierType.BOMB:
				body.apply_modifier('bombs', get_operation(), amount, duration, body.sig_bombs_updated);
			ModifierType.KEY:
				body.apply_modifier('keys', get_operation(), amount, duration, body.sig_keys_updated);
			'_':
				pass


func get_operation() -> String:
	var operator = ''
	match operation_type:
		OperationType.ADD:
			operator = '+'
		OperationType.SUBTRACT:
			operator = '-'
		OperationType.MULTIPLY:
			operator = '*'
		OperationType.DIVIDE:
			operator = '/'
		OperationType.ASSIGN:
			operator = '='
		'_':
			operator = ''
	return operator
