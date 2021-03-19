extends ColorRect


onready var tween = $Tween
onready var player = get_node("/root/Main/Player")
onready var maze = get_node("/root/Main/Maze")

var tween_lock = false
var flashColor : Color

signal transitionMidSignal

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("transitionMidSignal", maze, "_moveRoomTransition")
	# TODO Add to combatGUI connect

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _setColor(inColor):
	flashColor = Color(inColor.r, inColor.g, inColor.b, 0.0)

func _startTransition():
	if(tween_lock):
		return
		
	player._lockCharacter(true)
	
	tween_lock = true
	var startColor = flashColor
	tween.interpolate_property(self, "color", Color(startColor.r, startColor.g, startColor.b, 0), Color(startColor.r, startColor.g, startColor.b, 1.0), 0.5, Tween.TRANS_QUINT, Tween.EASE_IN)
	
	tween.start()
	
	self.visible = true
	
	yield(tween, "tween_completed")
	
	tween.interpolate_property(self, "color", Color(color.r, color.g, color.b, 1.0), Color(startColor.r, startColor.g, startColor.b, 0), 0.5, Tween.TRANS_QUINT, Tween.EASE_IN)
	
	tween.start()
	
	emit_signal("transitionMidSignal")
	
	yield(tween, "tween_completed")
	
	tween_lock = false
	
	self.visible = false
	
	player._lockCharacter(false)


