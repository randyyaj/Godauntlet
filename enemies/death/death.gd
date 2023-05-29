class_name Death
extends Enemy

@export var max_damage_inflicted = 200
var damage_dealt := 0
var target: Player

func _ready() -> void:
	super()
	attack_area.area_exited.connect(_on_area_2d_area_exited)

func _physics_process(delta: float) -> void:
	super(delta)
	
	if (target and damage_dealt < max_damage_inflicted):
		target.health -= power
		damage_dealt += 1
	
	if (damage_dealt >= max_damage_inflicted):
		die()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		target = area.get_parent()


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		target = null
