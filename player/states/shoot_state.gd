class_name ShootState
extends BaseState

@export var projectile: PackedScene

var projectile_direction = Vector2.DOWN
var is_shooting := false
var can_fire := true
var can_fire_timer: Timer = Timer.new()


func _ready():
	state_name = 'SHOOT'
	can_fire_timer.timeout.connect(_on_can_fire_timer_timeout)
	add_child(can_fire_timer)
	

func on_enter(_msg := {}) -> void:
	super()
	animation_tree['parameters/conditions/is_shooting'] = true
	can_fire_timer.wait_time = character.fire_rate
	can_fire_timer.start()


func on_exit() -> void:
	animation_tree['parameters/conditions/is_shooting'] = false


func state_input(event: InputEvent):
	if (can_fire):
		projectile_direction = Input.get_vector("control_left", "control_right", "control_up", "control_down")
		animation_tree.set("parameters/Shoot/blend_position", projectile_direction)
	
		if (projectile_direction == Vector2.ZERO):
			projectile_direction = character.last_facing_direction
			animation_tree.set("parameters/Shoot/blend_position", projectile_direction)
		
		shoot_projectile()


func shoot_projectile() -> void:
	var bullet = projectile.instantiate()
	bullet.power = character.shot_power
	bullet.speed = character.shot_speed
	bullet.is_bouncy = true
	bullet.global_position = character.global_position
	bullet.direction = projectile_direction
	get_tree().get_root().add_child(bullet)
	can_fire = false


func _on_can_fire_timer_timeout():
	if Input.is_action_pressed("shoot"):
		var cancel_event = InputEventAction.new()
		cancel_event.action = "shoot"
		cancel_event.pressed = true
		Input.parse_input_event(cancel_event)
	can_fire = true




