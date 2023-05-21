class_name Player
extends CharacterBody2D

signal sig_death
signal sig_health_updated
signal sig_score_updated
signal sig_speed_updated

signal sig_set_shot_speed(amount: int)
signal sig_reset_shot_speed
signal sig_shot_speed_updated

signal sig_set_magic_power(amount: int)
signal sig_reset_magic_power
signal sig_magic_power_updated

signal sig_set_power(amount: int)
signal sig_reset_power
signal sig_power_updated

signal sig_set_shot_power(amount: int)
signal sig_reset_shot_power
signal sig_shot_power_updated

signal sig_set_defense(amount: int)
signal sig_reset_defense
signal sig_defense_updated
signal sig_bombs_updated
signal sig_keys_updated
signal sig_fire_rate_updated

var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()

@export var max_health := 9999
@export var max_power := 0
@export var max_speed := 900
@export var health := 9999
@export var power := 1
@export var shot_power := 1
@export var defense := 0
@export var score := 0
@export var speed: int = 200
@export var shot_speed := 200
@export var magic_power: int = 1
@export var bombs: int = 0
@export var keys: int = 0
@export var fire_rate: float = 0.25

@export var sfx_shoot: AudioStream
@export var sfx_hurt: AudioStream
@export var sfx_death: AudioStream
@export var projectile: PackedScene
@export var attack_offset := 16
@onready var health_timer: Timer = $HealthTimer
@onready var can_fire_timer = $CanFireTimer
@onready var bomb_explosion_area = $BombExplosionArea

var projectile_direction = Vector2.DOWN
var is_shooting := false
var can_fire := true

## Connect signals to functions within script
func _connect_signals():
	sig_add_health.connect(add_health) 
	sig_subtract_health.connect(subtract_health)
	sig_add_score.connect(add_score)
	sig_subtract_score.connect(subtract_score)
	sig_apply_modifier.connect(apply_modifier)
	sig_set_speed.connect(set_speed)
	sig_reset_speed.connect(reset_speed)
	sig_set_shot_speed.connect(set_shot_speed)
	sig_reset_shot_speed.connect(reset_shot_speed)
	sig_set_magic_power.connect(set_magic_power)
	sig_reset_magic_power.connect(reset_magic_power)
	sig_set_power.connect(set_power)
	sig_reset_power.connect(reset_power)
	sig_set_shot_power.connect(set_shot_power)
	sig_reset_shot_power.connect(reset_shot_power)
	sig_set_defense.connect(set_defense)
	sig_reset_defense.connect(reset_defense)
	sig_add_bomb.connect(add_bombs)
	sig_add_key.connect(add_key)


func _ready() -> void:
	PlayerManager.player = self
	can_fire_timer.wait_time = fire_rate
	can_fire_timer.start()


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("control_left", "control_right", "control_up", "control_down")
	if (direction != Vector2.ZERO):
		projectile_direction = direction
	velocity = direction.normalized() * speed * delta
	
	if (not is_shooting):
		var collision = move_and_collide(velocity)
		if (collision):
			check_door_collision(collision.get_collider())
	
	if (is_shooting and can_fire):
		shoot_projectile()


func check_door_collision(body: Node2D) -> void:
	if (body is Door):
		if (keys > 0):
			subtract_keys(1)
			body.queue_free()


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
func apply_modifier(property_name: StringName, operand: StringName, amount: int, duration: float) -> void:
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
		&"=", &"ASSIGN":
			set(property_name, amount)
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


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		is_shooting = true

	if event.is_action_released("shoot"):
		is_shooting = false
	
	if event.is_action_pressed("bomb"):
		use_bomb()
		

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("control_left", "control_right", "control_up", "control_down")
	if (direction != Vector2.ZERO):
		projectile_direction = direction
	
	attack_area.position = direction * attack_offset
	
	if (not is_shooting):
		var collision = move_and_collide(velocity)
	
	if (is_shooting and can_fire):
		shoot_projectile()
	
	velocity = direction.normalized() * speed * delta
	


## Wrapper function allows us to specify a property name and apply operator logic on it
## Example emit_signal('health', '+', 4) | emit_signal('health', 'ADD', 4) | emit_signal('health', 'PLUS', 2) | emit_signal('health', 'add', 2)
func apply_modifier(property_name: StringName, operand: StringName, amount: int, duration: float) -> void:
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
		&"=", &"ASSIGN":
			set(property_name, amount)
		_:
			pass
	

func shoot_projectile() -> void:
	# fires projectile in facing direction
	var bullet = projectile.instantiate()
	bullet.power = shot_power
	bullet.speed = shot_speed
	bullet.global_position = global_position
	bullet.direction = projectile_direction
	get_tree().get_root().add_child(bullet)
	can_fire = false


func use_bomb() -> void:
	# consumes potion and performs an area of affect attack
	# if magic_power level is MAX(5) call enemies group die() wiping all current enemy on screen else multiply BombCollisionShape * magic_power power
	if (bombs != 0):
		subtract_bombs(1)
		var bodies = bomb_explosion_area.get_overlapping_bodies()
		for body in bodies:
			body.die()


func set_speed(amount: int) -> void:
	speed = amount
	sig_speed_updated.emit(speed)


func reset_speed() -> void:
	speed = max_speed
	sig_speed_updated.emit(speed)
	

func set_magic_power(amount: int) -> void:
	magic_power = amount
	sig_magic_power_updated.emit(magic_power)


func reset_magic_power() -> void:
	magic_power = 1
	sig_magic_power_updated.emit(magic_power)
	

func set_shot_power(amount: int) -> void:
	shot_power = amount
	sig_shot_power_updated.emit(shot_power)


func reset_shot_power() -> void:
	shot_power = 1
	sig_shot_power_updated.emit(shot_power)
	

func set_shot_speed(amount: int) -> void:
	shot_speed = amount
	sig_shot_speed_updated.emit(shot_speed)


func reset_shot_speed() -> void:
	shot_speed = 1
	sig_shot_speed_updated.emit(shot_speed)


func set_power(amount: int) -> void:
	power = amount
	sig_power_updated.emit(power)


func reset_power() -> void:
	power = 1
	sig_power_updated.emit(power)


func set_defense(amount: int) -> void:
	defense = amount
	sig_defense_updated.emit(defense)


func reset_defense() -> void:
	defense = 0
	sig_defense_updated.emit(defense)
	

func add_bombs(amount: int) -> void:
	bombs += amount
	sig_bombs_updated.emit(bombs)


func subtract_bombs(amount: int) -> void:
	bombs -= amount
	sig_bombs_updated.emit(bombs)


func add_key(amount: int) -> void:
	keys += amount
	sig_keys_updated.emit(keys)


func subtract_keys(amount: int) -> void:
	keys -= amount
	sig_keys_updated.emit(keys)


func _on_health_timer_timeout() -> void:
	health -= 1


func _on_can_fire_timer_timeout():
	can_fire = true
	

#checking for doors. If area entered, delete the fence and subtract a key
func _on_door_detector_body_entered(body):
	if body.is_in_group("Door") and (keys >= 1):
		keys -= 1
		body.queue_free()


func _on_attack_area_body_entered(body: Node2D) -> void:
	body.health -= power # Inflict damage to enemy
	attack_area.set_deferred("monitoring", false)
	attack_timer.start()
	

func _on_attack_timer_timeout() -> void:
	attack_area.set_deferred("monitoring", true)
