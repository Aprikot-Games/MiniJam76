extends Node2D

export (PackedScene) var Spot
export (PackedScene) var Bomb

signal found_bomb

const TILE_SIZE = 18
const TILE_OFFSET_X = TILE_SIZE * 0.5
const TILE_OFFSET_Y = TILE_SIZE * 1.5

const MIN_GEIGER_PER = 0.15
const MAX_GEIGER_PER = 0.75

var dug_map = []
var bomb_pos = [0, 0]

# Called when the node enters the scene tree for the first time.
func _ready():
	dug_map.resize(9)
	for i in range(9):
		dug_map[i] = []
		dug_map[i].resize(16)
	for i in range(9):
		for j in range(16):
			dug_map[i][j] = false
	randomize()
	# Place the bomb in a random position
	bomb_pos[0] = (randi()%8) + 1
	bomb_pos[1] = (randi()%15) + 1
	#print(bomb_pos[0])
	#print(bomb_pos[1])
	$Bomb.position.x = (bomb_pos[1] * 18) + 9
	$Bomb.position.y = (bomb_pos[0] * 18) + 9
	$Bomb.hide()
	$Player.position.x = 7 * TILE_SIZE + 9
	$Player.position.y = 4 * TILE_SIZE + 9

func set_player_speed(n):
	$Player.MAX_SPEED = n

func set_player_death():
	$Player.player_dead = true

func _on_Player_dig(pos):
	var new_spot = Spot.instance()
	if dug_map[pos[0]][pos[1]] == false:
		$TileMap.add_child(new_spot)
		new_spot.position.x = pos[1] * TILE_SIZE + TILE_OFFSET_X
		new_spot.position.y = pos[0] * TILE_SIZE + TILE_OFFSET_Y
		dug_map[pos[0]][pos[1]] = true
		$DigSFX.play()
	if pos[0] == bomb_pos[0] and pos[1] == bomb_pos[1]:
		emit_signal("found_bomb")
		$Bomb.show()
		#print("Win the game")

func _process(delta):
	var player_pos = $Player.get_tile_pos()
	var distance = abs(player_pos[0] - bomb_pos[0]) + abs(player_pos[1] - bomb_pos[1])
	var new_period = (distance * 0.025) + 0.1
	$GeigerTimer.wait_time = new_period

func _on_GeigerTimer_timeout():
	$GeigerClick.play()

func _on_rad_tick():
	$Player.MAX_SPEED -= 1
