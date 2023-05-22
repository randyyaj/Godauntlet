extends CanvasLayer

@onready var timer = $Timer
@onready var color_rect = $ColorRect
@onready var marker_2d = $Marker2D
@onready var myLevelList = preload("res://LevelDesign/LevelList1.tres")

var Main = preload("res://main.tscn")
var current_level_index = 0
var real_current_level_index = 1

@export var level_index_shuffler = 5

signal easy_level_beat

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func next_level_easy():
	real_current_level_index += 1
	current_level_index += randi_range(1,2)
	#Main.add_child(myLevelList.levelList[1])
	var tween = create_tween()
	tween.tween_property(color_rect,"position", marker_2d.position, .5)
	tween.tween_property(color_rect,"position", color_rect.position,.5)
	timer.start()
	if real_current_level_index % level_index_shuffler == 0:
		myLevelList.levelList.shuffle()
		print(str(myLevelList.levelList[1]))

func _on_easy_level_beat():
	next_level_easy()
	pass # Replace with function body.


func _on_timer_timeout():
	get_tree().change_scene_to_packed(myLevelList.levelList[current_level_index])
	pass # Replace with function body.
