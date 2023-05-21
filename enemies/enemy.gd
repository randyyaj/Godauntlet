class_name Enemy
extends CharacterBody2D

signal sig_death
signal sig_add_health
signal sig_health_updated
signal sig_subtract_health

@export var max_health := 3
@export var health := 3
@export var damage := 1
@export var defense := 0
@export var score := 100
@export var speed: int = 50

@onready var navigation_agent_2d = $NavigationAgent2D

## Connect signals to functions within script
func _connect_signals():
	sig_add_health.connect(add_health) 
	sig_subtract_health.connect(subtract_health)


func _ready():
	_connect_signals()
	add_to_group('enemies', true)
	

func _physics_process(delta: float) -> void:
	var distanceToTarget = global_position.distance_to(PlayerManager.player.get_global_position())
	navigation_agent_2d.set_target_position(PlayerManager.player.get_global_position())
	velocity = (navigation_agent_2d.get_next_path_position() - global_position).normalized() * speed * delta
	#move_and_slide()
	var collision = move_and_collide(velocity)
	
	#	if distanceToTarget > 20:
#		navigation_agent_2d.set_target_position(PlayerManager.player.get_global_position())
#	else:
#		navigation_agent_2d.target_reached.emit(true)
#	var collision = get_last_slide_collision()
#	print ("Collided with: " + collision.get_collider().name)
#	print ("Collider position: ", collision.get_collider().global_position)
	
	if (collision):
		var body = collision.get_collider()
		if (body == PlayerManager.player):
			body.sig_subtract_health.emit(damage) # Inflict damage to player



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


func die() -> void:
	sig_death.emit()
	PlayerManager.player.sig_add_score.emit(score)
	queue_free()
