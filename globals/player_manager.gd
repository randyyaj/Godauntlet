extends Node

#Global for tracking player position. Will be used for enemy path finding

var player: Player
var player_data: PlayerData

func get_global_position() -> Vector2:
	return player.get_global_position()


func get_global_transform() -> Transform2D:
	return player.get_global_transform()


func init_player_data() -> void:
	if (!player_data):
		player_data = PlayerData.new()

	if (player and player_data):
		print('initializing player data')
		player.max_health = player_data.max_health
		player.max_power = player_data.max_power
		player.max_speed = player_data.max_speed
		player.health = player_data.health
		player.power = player_data.power
		player.shot_power = player_data.shot_power
		player.defense = player_data.defense
		player.score = player_data.score
		player.speed = player_data.speed
		player.shot_speed = player_data.shot_speed
		player.magic_power = player_data.magic_power
		player.bombs = player_data.bombs
		player.keys = player_data.keys
		player.fire_rate = player_data.fire_rate


func set_player_data(p: Player) -> void:
	if (!player_data):
		player_data = PlayerData.new()
		
	player_data.max_health = p.max_health
	player_data.max_power = p.max_power
	player_data.max_speed = p.max_speed
	player_data.health = p.health
	player_data.power = p.power
	player_data.shot_power = p.shot_power
	player_data.defense = p.defense
	player_data.score = p.score
	player_data.speed = p.speed
	player_data.shot_speed = p.shot_speed
	player_data.magic_power = p.magic_power
	player_data.bombs = p.bombs
	player_data.keys = p.keys
	player_data.fire_rate = p.fire_rate
