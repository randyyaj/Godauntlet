class_name Player
extends CharacterBody2D

signal sig_death
signal sig_add_health(amount: int)
signal sig_subtract_health(amount: int)
signal sig_health_updated

signal sig_add_score
signal sig_subtract_score
signal sig_score_updated

signal sig_set_speed(amount: int)
signal sig_reset_speed
signal sig_speed_updated

signal sig_set_magic(amount: int)
signal sig_reset_magic
signal sig_magic_updated

signal sig_set_projectile_damage(amount: int)
signal sig_reset_projectile_damage
signal sig_projectile_damage_updated

signal sig_set_projectile_speed(amount: int)
signal sig_reset_projectile_speed
signal sig_projectile_speed_updated

signal sig_set_damage(amount: int)
signal sig_reset_damage
signal sig_damage_updated

signal sig_set_defense(amount: int)
signal sig_reset_defense
signal sig_defense_updated

signal sig_add_bomb
signal sig_bombs_updated

signal sig_add_keys
signal sig_keys_updated

signal sig_apply_modifier(property_name: StringName, operand: StringName, amount: int)

var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()

const DEFAULT_SPEED = 200.0
const DEFAULT_DAMAGE = 1
const DEFAULT_HEALTH = 9999
const DEFAULT_DEFENSE = 0
const DEFAULT_MAGIC = 0
const DEFAULT_PROJECTILE_DAMAGE = 1
const DEFAULT_PROJECTILE_SPEED = 200

@export var max_health := 9999
@export var max_damage := 0
@export var max_speed := 0
@export var health := 9999
@export var damage := 0
@export var defense := 0
#@export var resist := []
@export var score := 0
@export var speed: int = DEFAULT_SPEED
@export var magic: int = 0
@export var projectile_damage: int = 0
@export var projectile_speed: int = 0
@export var bombs: int = 0
@export var keys: int = 0

@export var sfx_shoot: AudioStream
@export var sfx_hurt: AudioStream
@export var sfx_death: AudioStream

@onready var health_timer: Timer = $HealthTimer

## Connect signals to functions within script
func _connect_signals():
	sig_add_health.connect(add_health) 
	sig_subtract_health.connect(subtract_health)
	sig_add_score.connect(add_score)
	sig_subtract_score.connect(subtract_score)
	sig_apply_modifier.connect(apply_modifier)
	sig_set_speed.connect(set_speed)
	sig_reset_speed.connect(reset_speed)
	sig_set_magic.connect(set_magic)
	sig_set_projectile_damage.connect(set_projectile_damage)
	sig_set_projectile_speed.connect(set_projectile_speed)
	sig_set_damage.connect(set_damage)
	sig_set_defense.connect(set_defense)
	sig_reset_defense.connect(reset_defense)
	sig_add_bomb.connect(add_bombs)
	sig_add_keys.connect(add_keys)

func _ready() -> void:
	_connect_signals()
	PlayerManager.player = self
	

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("control_left", "control_right", "control_up", "control_down")
	velocity = direction * speed
	move_and_slide()


func add_health(amount: int) -> void:
	if (health < max_health):
		if (health + amount > max_health):
			health = max_health
		else:
			health += amount
		sig_health_updated.emit(health)


func subtract_health(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()
	sig_health_updated.emit(health)


func add_score(amount: int) -> void:
	score += amount
	sig_score_updated.emit(score)


func subtract_score(amount: int) -> void:
	score -= amount
	sig_score_updated.emit(score)


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


func melee_attack() -> void:
	# performs a short range melee attack
	pass


func shoot_projectile() -> void:
	# fires projectile in facing direction
	pass


func use_bomb() -> void:
	# consumes potion and performs an area of affect attack
	pass


func set_speed(amount: int) -> void:
	speed = amount
	sig_speed_updated.emit(speed)


func reset_speed() -> void:
	speed = max_speed
	sig_speed_updated.emit(speed)
	

func set_magic(amount: int) -> void:
	magic = amount
	sig_magic_updated.emit(magic)


func reset_magic() -> void:
	magic = DEFAULT_MAGIC
	sig_magic_updated.emit(magic)


func set_projectile_damage(amount: int) -> void:
	projectile_damage = amount
	sig_projectile_damage_updated.emit(magic)


func reset_projectile_damage() -> void:
	projectile_damage = DEFAULT_PROJECTILE_DAMAGE
	sig_projectile_damage_updated.emit(magic)


func set_projectile_speed(amount: int) -> void:
	projectile_speed = amount
	sig_projectile_speed_updated.emit(projectile_speed)


func reset_projectile_speed() -> void:
	projectile_speed = DEFAULT_PROJECTILE_SPEED
	sig_projectile_speed_updated.emit(projectile_speed)
	

func set_damage(amount: int) -> void:
	damage = amount
	sig_damage_updated.emit(damage)


func reset_damage() -> void:
	damage = DEFAULT_DAMAGE
	sig_damage_updated.emit(damage)


func set_defense(amount: int) -> void:
	defense = amount
	sig_defense_updated.emit(defense)


func reset_defense() -> void:
	defense = DEFAULT_DEFENSE
	sig_defense_updated.emit(defense)
	

func add_bombs(amount: int) -> void:
	bombs += amount
	sig_bombs_updated.emit(bombs)


func subtract_bombs(amount: int) -> void:
	bombs += amount
	sig_bombs_updated.emit(bombs)


func add_keys(amount: int) -> void:
	keys += amount
	sig_keys_updated.emit(keys)


func subtract_keys(amount: int) -> void:
	keys += amount
	sig_keys_updated.emit(keys)


func _on_health_timer_timeout() -> void:
	subtract_health(1)
