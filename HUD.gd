extends CanvasLayer

var g_stack = []
var g_activeMsg = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Function to send a temporal notification message to the game
func notify(msg):
	g_stack.push_front(msg)

func set_message(msg):
	$Msg.text = msg
	$Msg.show()
	$MsgTimer.start()

func set_level(level):
	$Level.text = "Bomb count: " + str(level)

func show_play_UI(show):
	if show == true:
		$Level.show()
		$Msg.show()
		$Bar.show()
	else:
		$Level.hide()
		$Msg.hide()
		$Bar.hide()

func show_menu_UI(show):
	if show == true:
		$StartButton.show()
		$Cover.show()
		$Background.show()
	else:
		$StartButton.hide()
		$Cover.hide()
		$Background.hide()

func _on_MsgTimer_timeout():
	$Msg.text = ""
	$Msg.hide()
	g_activeMsg = false

func _process(delta):
	if g_activeMsg == false and g_stack.size() > 0:
		g_activeMsg = true
		set_message(g_stack.pop_back())
