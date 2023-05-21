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
	match modifier_type:
		ModifierType.HEALTH:
			body.sig_apply_modifier.emit('health', get_operation(), amount, duration);
			body.sig_health_updated.emit(amount)
		ModifierType.SPEED:
			body.sig_apply_modifier.emit('speed', get_operation(), amount, duration);
			body.sig_speed_updated.emit(amount)
		ModifierType.SHOT_SPEED:
			body.sig_apply_modifier.emit('shot_speed', get_operation(), amount, duration);
			body.sig_shot_speed_updated.emit(amount)
		ModifierType.POWER:
			body.sig_apply_modifier.emit('power', get_operation(), amount, duration);
			body.sig_power_updated.emit(amount)
		ModifierType.SHOT_POWER:
			body.sig_apply_modifier.emit('shot_power', get_operation(), amount, duration);
			body.sig_shot_power_updated.emit(amount)
		ModifierType.MAGIC_POWER:
			body.sig_apply_modifier.emit('magic_power', get_operation(), amount, duration);
			body.sig_magic_power_updated.emit(amount)
		ModifierType.DEFENSE:
			body.sig_apply_modifier.emit('defense', get_operation(), amount, duration);
			body.sig_defense_updated.emit(amount)
		ModifierType.SCORE:
			body.sig_apply_modifier.emit('score', get_operation(), amount, duration);
			body.sig_score_updated.emit(amount)
		ModifierType.BOMB:
			body.sig_apply_modifier.emit('bombs', get_operation(), amount, duration);
			body.sig_bombs_updated.emit(amount)
		ModifierType.KEY:
			body.sig_apply_modifier.emit('keys', get_operation(), amount, duration);
			body.sig_keys_updated.emit(amount)
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
