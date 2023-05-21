extends CharacterBody2D

@export var power := 1
@export var texture: AtlasTexture
@export var speed := 400
@export var is_bouncy := false
@export var is_piercing := false

@onready var collision_shape_2d = $CollisionShape2D
@onready var time_to_live_timer = $TimeToLiveTimer
@onready var time_to_live = 3
@onready var sprite_2d = $Sprite2D

var direction = Vector2.ZERO
var angleChange = 45
var restitution = 0.8

func _connect_signals():
	time_to_live_timer.timeout.connect(_on_time_to_live_timer_timeout)


# Called when the node enters the scene tree for the first time.
func _ready():
	power = player.shot_power
	speed = player.shot_speed
	sprite_2d.texture = texture
	time_to_live_timer.wait_time = time_to_live
	time_to_live_timer.start()
	velocity = direction.normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(velocity * speed * delta)
	if (collision):
		var body = collision.get_collider()
		
		if (is_bouncy):
			var collision_normal = body.transform.basis_xform_inv(collision.get_normal())
			velocity = velocity.bounce(collision_normal)
		
		if (is_piercing):
			set_collision_mask_value(1, false) # Tilemap Mask
			set_collision_mask_value(3, false) # Wall Mask
			
		if ('health' in body):
			body.health -= power
			queue_free()
		else:
			if (!is_bouncy and !is_piercing):
				queue_free()

func _on_time_to_live_timer_timeout():
	queue_free()
