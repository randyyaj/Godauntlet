extends VBoxContainer

signal sig_update_health(health)
signal sig_update_score(score)

var player: Player
@export var player_node_path: NodePath
@onready var player_name: Label = $PlayerName
@onready var score_label: Label = $HSplitContainer/ScoreContainer/ScoreLabel
@onready var score_value: Label = $HSplitContainer/ScoreContainer/ScoreValue
@onready var health_label: Label = $HSplitContainer/HealthContainer/HealthLabel
@onready var health_value: Label = $HSplitContainer/HealthContainer/HealthValue

func connect_signals() -> void:
	sig_update_health.connect(update_health)
	sig_update_score.connect(update_score)
	
	# Listen on player health
	player.sig_health_updated.connect(update_health)
	
	# Listen on player score
	player.sig_score_updated.connect(update_score)


func _ready() -> void:
	if (player_node_path):
		player = await get_node(player_node_path)
	else:
		player = PlayerManager.player

	connect_signals()
	health_value.text = str(player.health)
	score_value.text = str(player.score)


func update_health(health: int) -> void:
	health_value.text = str(health)


func update_score(score: int) -> void:
	score_value.text = str(score)

