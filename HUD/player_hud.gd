extends Control

@onready var score_label: Label = $ScoreLabel
@onready var health_label: Label = $HealthLabel
@onready var defense_label: Label = $PlayerStats/DefenseIcon/DefenseLabel
@onready var attack_label: Label = $PlayerStats/AttackIcon/AttackLabel
@onready var magic_label: Label = $PlayerStats/MagicIcon/MagicLabel
@onready var speed_label: Label = $PlayerStats/SpeedIcon/SpeedLabel
@onready var key_label: Label = $SideStats/KeyContainer/KeyLabel
@onready var potion_label: Label = $SideStats/PotionContainer/PotionLabel

signal sig_update_health(health)
signal sig_update_score(score)
signal sig_update_defense(defnse)
signal sig_update_attack(attack)
signal sig_update_magic(magic)
signal sig_update_speed(speed)
signal sig_update_keys(keys)
signal sig_update_bombs(bombs)

var player: Player
@export var player_node_path: NodePath
#@onready var player_name: Label = $PlayerName

func connect_signals() -> void:
	sig_update_health.connect(update_health)
	sig_update_score.connect(update_score)
	
	# Listen on player stats
	player.sig_health_updated.connect(update_health)
	player.sig_score_updated.connect(update_score)
	player.sig_defense_updated.connect(update_defense)
	player.sig_damage_updated.connect(update_attack)
	player.sig_magic_updated.connect(update_magic)
	player.sig_speed_updated.connect(update_speed)
	player.sig_keys_updated.connect(update_keys)
	player.sig_bombs_updated.connect(update_bombs)


func _ready() -> void:
	if (player_node_path):
		player = get_node(player_node_path)
	else:
		player = PlayerManager.player

	connect_signals()
	
	health_label.text = 'HEALTH: ' + str(player.health)
	score_label.text = 'SCORE: ' + str(player.score)
	defense_label.text = str(player.defense)
	attack_label.text = str(player.damage)
	magic_label.text = str(player.magic)
	speed_label.text = str(player.speed)
	key_label.text = str(player.keys)
	potion_label.text = str(player.bombs)


func update_health(health: int) -> void:
	health_label.text = 'HEALTH: ' + str(health)


func update_score(score: int) -> void:
	score_label.text = 'SCORE: ' + str(score)


func update_defense(amount: int) -> void:
	defense_label.text = str(amount)
	
	
func update_attack(amount: int) -> void:
	attack_label.text = str(amount)
	
	
func update_magic(amount: int) -> void:
	magic_label.text = str(amount)
	
	
func update_speed(amount: int) -> void:
	speed_label.text = str(amount)
	
	
func update_keys(amount: int) -> void:
	key_label.text = str(amount)
	
	
func update_bombs(amount: int) -> void:
	potion_label.text = str(amount)
	
