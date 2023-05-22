extends CharacterBody2D

@export var power := 1
@export var texture: AtlasTexture
@export var speed := 400
@onready var collision_shape_2d = $CollisionShape2D
@onready var time_to_live_timer = $TimeToLiveTimer
@onready var time_to_live = 5
@onready var sprite_2d = $Sprite2D

var direction = Vector2.ZERO


func _connect_signals():
	time_to_live_timer.timeout.connect(_on_time_to_live_timer_timeout)


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d.texture = texture
	time_to_live_timer.wait_time = time_to_live
	time_to_live_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(direction.normalized() * speed * delta)
	if (collision):
		var body = collision.get_collider()
		if ('health' in body):
			body.health -= power
		queue_free()


func _on_time_to_live_timer_timeout():
	queue_free()
