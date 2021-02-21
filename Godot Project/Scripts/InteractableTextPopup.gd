extends RichTextLabel


export var labelText = "E"

# Called when the node enters the scene tree for the first time.
func _ready():	
	_hide()

func _init():
	_hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _show():
	self.visible = true
	
func _hide():
	self.visible = false
