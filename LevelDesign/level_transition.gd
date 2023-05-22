extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var marker_2d = $Marker2D
@onready var myLevelList = preload("res://LevelDesign/LevelList1.tres")
var Main = preload("res://main.tscn")
var current_level_index = 0

signal level_beat

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func next_level():
	current_level_index += randi_range(1,2)
	#Main.add_child(myLevelList.levelList[1])
	var tween = create_tween()
	tween.tween_property(color_rect,"position", marker_2d.position, .5)
	tween.tween_property(color_rect,"position", color_rect.position,.5)


func _on_level_beat():
	next_level()
	pass # Replace with function body.
