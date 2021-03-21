extends KinematicBody2D

const ACCELERATION = 8000
const MAX_SPEED = 90
const FRICTION = 0.3

signal dig(pos)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("dig"):
		$Sprite.animation = "dig"
		var dig_pos = get_tile_pos()
		emit_signal("dig", dig_pos)
		return
		
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	var motion = Vector2(0,0)
	
	if x_input == 0:
		if y_input > 0:
			$Sprite.animation = "south_walk"
		elif y_input < 0:
			$Sprite.animation = "north_walk"
		elif y_input == 0:
			$Sprite.animation = "south"
	elif x_input > 0:
		$Sprite.animation = "east_walk"
	elif x_input < 0:
		$Sprite.animation = "west_walk"
	
	if x_input != 0:
		motion.x += x_input * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	if y_input != 0:
		motion.y += y_input * ACCELERATION * delta
		motion.y = clamp(motion.y, -MAX_SPEED, MAX_SPEED)
	move_and_slide(Vector2(motion.x, motion.y))

func get_tile_pos():
	var c = floor(position.x/18)
	var r = floor(position.y/18)
	return [r, c]
