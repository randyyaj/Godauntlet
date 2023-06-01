extends Node2D

@export var item_choice1 : Randomizer
@export var item_choice2 : Randomizer
@export var item_choice3 : Randomizer

@onready var choice_1_postion = $Positions/Choice1Postion
@onready var choice_2_postion = $Positions/Choice2Postion
@onready var choice_3_postion = $Positions/Choice3Postion
@onready var potions = $Potions
@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	#randomize and create item
	shuffle()
	instantiationate()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if potions.get_child_count() == 2: #used to kill the node when item is collected
		animation_player.play("Shrink")
		pass

func shuffle() -> void: #shuffles item choices
	item_choice1.randomList.shuffle()
	item_choice2.randomList.shuffle()
	item_choice3.randomList.shuffle()
	
func instantiationate(): #creates items
	var choice1 = item_choice1.randomList[0].instantiate()
	var choice2 = item_choice2.randomList[0].instantiate()
	var choice3 = item_choice3.randomList[0].instantiate()
	
	potions.add_child(choice1)
	potions.add_child(choice2)
	potions.add_child(choice3)
	
	choice1.position = choice_1_postion.position
	choice2.position = choice_2_postion.position
	choice3.position = choice_3_postion.position
	
func kill():
	queue_free()
