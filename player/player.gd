class_name Player
extends CharacterBody2D

signal sig_death
signal sig_health_updated
signal sig_score_updated
signal sig_speed_updated
signal sig_shot_speed_updated
signal sig_magic_power_updated
signal sig_power_updated
signal sig_shot_power_updated
signal sig_defense_updated
signal sig_bombs_updated
signal sig_keys_updated
signal sig_fire_rate_updated
signal on_projectile_hit
signal on_melee_hit

var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()

@export var default_health := 700
@export var default_power := 1
@export var default_speed := 100
@export var default_shot_power := 1
@export var default_shot_speed := 200
@export var default_magic_power := 0
@export var default_defense := 0
@export var default_fire_rate := .25

@export var max_health := 9999
@export var max_power := 3
@export var max_speed := 500
@export var max_shot_power := 3
@export var max_shot_speed := 500
@export var max_magic_power := 3
@export var max_defense := 3
@export var max_fire_rate := .1

@export var health := default_health :
	get:
		return health
	set(value):
		health = value
		sig_health_updated.emit(health)
		if (health <= 0 or value > health):
			die()
		
@export var power := 1 :
	get:
		return power
	set(value):
		power = value
		sig_power_updated.emit(power)
		
@export var shot_power := 1 :
	get:
		return shot_power
	set(value):
		shot_power = value
		sig_shot_power_updated.emit(shot_power)

@export var defense := 0 :
	get:
		return defense
	set(value):
		defense = value
		sig_defense_updated.emit(defense)
		
@export var score := 0:
	get:
		return score
	set(value):
		score = value
		sig_score_updated.emit(score)
		
@export var speed: int = 100 : 
	get:
		return speed
	set(value):
		speed = value
		sig_speed_updated.emit(speed)

@export var shot_speed := 200 : 
	get:
		return shot_speed
	set(value):
		shot_speed = value
		sig_shot_speed_updated.emit(shot_speed)
		
@export var magic_power: int = 1 : 
	get:
		return magic_power
	set(value):
		magic_power = value
		sig_magic_power_updated.emit(magic_power)
		
@export var bombs: int = 0 : 
	get:
		return bombs
	set(value):
		bombs = value
		sig_bombs_updated.emit(bombs)
		
@export var keys: int = 0 : 
	get:
		return keys
	set(value):
		keys = value
		sig_keys_updated.emit(keys)

@export var fire_rate: float = 0.25 : 
	get:
		return fire_rate
	set(value):
		fire_rate = value
		sig_fire_rate_updated.emit(fire_rate)

@export var sfx_shoot: AudioStream
@export var sfx_hurt: AudioStream
@export var sfx_death: AudioStream
@export var attack_offset := 16

@onready var health_timer: Timer = $HealthTimer
@onready var blast_radius =$BlastRadius
@onready var blast_radius_shape: CollisionShape2D = $BlastRadius/BlastRadiusShape
@onready var attack_area: Area2D = $AttackArea
@onready var attack_timer: Timer = $AttackTimer
@onready var attack_area_collision: CollisionShape2D = $AttackArea/AttackAreaCollision
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: Node = $StateMachine

var last_facing_direction: Vector2 = Vector2.DOWN

func _ready() -> void:
	PlayerManager.player = self
	animation_tree.active = true
	on_projectile_hit.connect(_on_projectile_hit)
	on_melee_hit.connect(_on_melee_hit)


func _input(event: InputEvent) -> void:
	if ((event.is_action_pressed('control_down') ||
		event.is_action_pressed('control_up') ||
		event.is_action_pressed('control_left') ||
		event.is_action_pressed('control_right')) && 
		state_machine.current_state.state_name != 'SHOOT'
	):
		last_facing_direction = Input.get_vector("control_left", "control_right", "control_up", "control_down")
		state_machine.change_state(state_machine.get_state('WALK'))
	
	if event.is_action_pressed("shoot"):
		state_machine.change_state(state_machine.get_state('SHOOT'))

	if event.is_action_released("shoot"):
		state_machine.change_state(state_machine.get_state('IDLE'))
		
	if event.is_action_pressed("bomb"):
		use_bomb()
	
	var direction = Input.get_vector("control_left", "control_right", "control_up", "control_down")
	attack_area.position = direction * attack_offset
		
	if (state_machine.current_state):
		state_machine.current_state.state_input(event)


func _physics_process(delta: float) -> void:
	if (state_machine.current_state):
		state_machine.current_state.state_physics_process(delta)


## Wrapper function allows us to specify a property name and apply operator logic on it
## Example emit_signal('health', '+', 4) | emit_signal('health', 'ADD', 4) | emit_signal('health', 'PLUS', 2) | emit_signal('health', 'add', 2)
func apply_modifier(property_name: StringName, operand: StringName, amount: int, duration: float) -> void:
	var property: Variant = get(property_name)
	var previous_property_value = get(property_name)
	match operand:
		&"+", &"ADD", &"add", &"PLUS", &"plus":
			set(property_name, property + amount)
		&"-", &"SUBTRACT", &"subtract", &"MINUS", &"minus":
			set(property_name, property - amount)
		&"*", &"MULTIPLY", &"multiply":
			set(property_name, property * amount)
		&"/", &"DIVIDE", &"divide":
			set(property_name, property / amount)
		&"=", &"ASSIGN":
			set(property_name, amount)
		_:
			pass
	
	# Reset property value if duration is present
	if (previous_property_value and duration):
		await get_tree().create_timer(duration).timeout
		set(property_name, previous_property_value)
		


func use_bomb() -> void:
	# consumes potion and performs an area of affect attack
	# if magic_power level is MAX(5) call enemies group die() wiping all current enemy on screen else multiply BombCollisionShape * magic_power power
	if (bombs != 0):
		bombs -= 1
		var bodies = blast_radius.get_overlapping_bodies()
		for body in bodies:
			body.die()


func die() -> void:
	# TODO present gameover screen
	get_tree().call_group("enemies", "set_target_position", null)
	queue_free()
	if (sfx_death):
		audio_stream_player.stream = sfx_death
		audio_stream_player.play()
		await audio_stream_player.finished
	# TODO await animation if there is an animation
	sig_death.emit()
	


func _on_health_timer_timeout() -> void:
	health -= 1
	

#checking for doors. If area entered, delete the fence and subtract a key
func _on_door_detector_body_entered(body):
	if body.is_in_group("Door") and (keys >= 1):
		keys -= 1
		body.queue_free()



func _on_attack_area_body_entered(body: Node2D) -> void:
	if (body.is_in_group('enemies') and !body.is_melee_proof and state_machine.current_state.state_name != 'SHOOT'):
		state_machine.change_state(state_machine.get_state('MELEE'))
		body.health -= power # Inflict damage to enemy
		attack_area.set_deferred("monitoring", false)
		attack_timer.start()


func _on_attack_timer_timeout() -> void:
	attack_area.set_deferred("monitoring", true)


func _on_projectile_hit(projectile: Projectile, knockback_strength: float) -> void:
	state_machine.change_state(state_machine.get_state('HURT'))
	health -= projectile.power


func _on_melee_hit(damage_amount: int) -> void:
	state_machine.change_state(state_machine.get_state('HURT'))
	health -= damage_amount
	
