extends Control

@onready var menu_panel = $MenuPanel
@onready var exit_button_panel = $MenuPanel/ExitButtonPanel
@onready var menu_title_label = $MenuPanel/MenuTitleLabel
@onready var menu_body_label = $MenuPanel/MenuBodyLabel
@onready var quit_yes_and_no_buttons = $MenuPanel/QuitYesAndNoButtons

var menuVisible = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://ui/Menus/ChooseClass.tscn")
	pass # Replace with function body.


func _on_how_to_play_pressed():
	menu_title_label.text = "How to Play"
	menu_body_label.text = "WASD/Arrows : move
J: Shoot
K: Spell
L: Potion
Esc: Pause"
	menu_panel.visible = true
	pass # Replace with function body.\
	


func _on_exit_button_pressed():
	menu_panel.visible = false
	pass # Replace with function body.


func _on_options_pressed():
	menu_panel.visible = true
	menu_title_label.text = "Options"
	menu_body_label.text = "Options go here"
	pass # Replace with function body.


func _on_credits_pressed():
	menu_panel.visible = true
	menu_title_label.text = "Credits"
	menu_body_label.text = "Created by Shuntoon and Randyyaj
Assets Used:"
	pass # Replace with function body.


func _on_quit_pressed():
	menu_title_label.add_theme_font_size_override("font_size",12)
	menu_panel.visible = true
	quit_yes_and_no_buttons.visible = true
	menu_title_label.text = "Are you sure you Want to quit?"
	menu_body_label.text = ""
	pass # Replace with function body.


func _on_exit_yes_button_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_exit_no_button_pressed():
	quit_yes_and_no_buttons.visible = false
	menu_panel.visible = false
	pass # Replace with function body.
