class_name Player
extends CharacterBody2D

#@export var state: StateResource

const SPEED = 200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("control_left", "control_right", "control_up", "control_down")
	velocity = direction * SPEED
	move_and_slide()


func melee_attack() -> void:
	# performs a short range melee attack
	pass


func shoot_projectile() -> void:
	# fires projectile in facing direction
	pass


func magic_attack() -> void:
	# consumes potion and performs an area of affect attack
	pass

signal sig_death
signal sig_add_health(amount: int)
signal sig_subtract_health(amount: int)
signal sig_add_speed(amount: int)
signal sig_subtract_speed(amount: int)
signal sig_reset_speed
signal sig_apply_modifier(property_name: StringName, operand: StringName, amount: int)

var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()

@export var max_health := 0
@export var max_damage := 0
@export var max_speed := 0
@export var health := 0
@export var damage := 0
@export var resist := []
@export var score := 0
@export var speed: int = 0

@export var sfx_shoot: AudioStream
@export var sfx_hurt: AudioStream
@export var sfx_death: AudioStream

## Connect signals to functions within script
func _connect_signals():
	sig_add_health.connect(add_health) 
	sig_subtract_health.connect(subtract_health)
	sig_add_speed.connect(add_speed)
	sig_subtract_speed.connect(subtract_speed)
	sig_reset_speed.connect(reset_speed)
	sig_apply_modifier.connect(apply_modifier)


func _ready() -> void:
	_connect_signals()
	health = max_health


func add_health(amount: int) -> void:
	if (health < max_health):
		if (health + amount > max_health):
			health = max_health
		else:
			health += amount


func subtract_health(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()


func add_speed(amount: int) -> void:
	if (speed < max_speed):
		speed += amount


func subtract_speed(amount: int) -> void:
	if (speed > 1):
		speed -= amount


func reset_speed() -> void:
	speed = max_speed


## Wrapper function allows us to specify a property name and apply operator logic on it
## Example emit_signal('health', '+', 4) | emit_signal('health', 'ADD', 4) | emit_signal('health', 'PLUS', 2) | emit_signal('health', 'add', 2)
func apply_modifier(property_name: StringName, operand: StringName, amount: int) -> void:
	var property: Variant = get(property_name)
	match operand:
		&"+", &"ADD", &"add", &"PLUS", &"plus":
			set(property_name, property + amount)
		&"-", &"SUBTRACT", &"subtract", &"MINUS", &"minus":
			set(property_name, property - amount)
		&"*", &"MULTIPLY", &"multiply":
			set(property_name, property * amount)
		&"/", &"DIVIDE", &"divide":
			set(property_name, property / amount)
		_:
			pass


func die() -> void:
	health = 0
	if (sfx_death):
		audio_stream_player.stream = sfx_death
		audio_stream_player.play()
		await audio_stream_player.finished
	# await animation if there is an animation
	emit_signal('sig_death')
