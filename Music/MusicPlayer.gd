extends Node

@export var MusicList : MusicCollection
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_stream_player_2d.stream = MusicList.MusicList.front().Song
	audio_stream_player_2d.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ChangeMusicTrack"):
		pick_random_song()
		pass
	pass
	
func pick_random_song():
	#audio_stream_player_2d.stop()
	audio_stream_player_2d.stream = MusicList.MusicList.pick_random().Song
	audio_stream_player_2d.stop()
	audio_stream_player_2d.play()
