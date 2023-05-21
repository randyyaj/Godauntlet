extends Control

@onready var are_you_sure = $Panel/AreYouSure
@onready var song_label = $SongLabel

var is_paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	song_label.text = str(MusicPlayer.currentSongName)
	if Input.is_action_just_pressed("pause") and not is_paused:
		Engine.time_scale = 0
		visible = true
		is_paused = true
	elif Input.is_action_just_pressed("pause") and is_paused:
		Engine.time_scale = 1
		is_paused = false
		visible = false
	pass


func _on_quit_button_pressed():
	are_you_sure.visible = true
	pass # Replace with function body.


func _on_continue_button_pressed():
	Engine.time_scale = 1
	visible = false
	pass # Replace with function body.


func _on_yes_button_pressed():
	get_tree().change_scene_to_file("res://ui/Menus/main_menu.tscn")
	pass # Replace with function body.


func _on_no_button_pressed():
	are_you_sure.visibility_changed =false
	pass # Replace with function body.
