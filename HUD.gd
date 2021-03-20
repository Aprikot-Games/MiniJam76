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

func _on_MsgTimer_timeout():
	$Msg.text = ""
	$Msg.hide()
	g_activeMsg = false

func _process(delta):
	if g_activeMsg == false and g_stack.size() > 0:
		g_activeMsg = true
		set_message(g_stack.pop_back())
