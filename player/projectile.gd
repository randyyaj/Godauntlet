extends CharacterBody2D

@export var power := 1
@export var texture: AtlasTexture
@export var speed := 400
@onready var area_2d = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var time_to_live_timer = $TimeToLiveTimer
@onready var sprite_2d = $Sprite2D

var direction = Vector2.ZERO
var player = PlayerManager.player

# Called when the node enters the scene tree for the first time.
func _ready():
	power = player.shot_power
	speed = player.shot_speed
	sprite_2d.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(direction.normalized() * speed * delta)
	if (collision):
		var body = collision.get_collider()
		if (body.has_signal('sig_subtract_health')):
			body.sig_subtract_health.emit(power)
		queue_free()


func _on_time_to_live_timer_timeout():
	pass # Replace with function body.
