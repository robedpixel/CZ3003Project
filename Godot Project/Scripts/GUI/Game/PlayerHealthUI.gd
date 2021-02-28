extends Node


onready var heartObj = preload("res://Scenes/Prefabs/Heart.tscn")

var heartCount = 0
var HEARTUI_OFFSET_X = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	_createHearts(3)
	_setHeart(2, 4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _createHearts(noOfHearts):
	for i in noOfHearts:
		var heartInstance = heartObj.instance()
		add_child(heartInstance)
		heartInstance.set_position(Vector2(heartCount * HEARTUI_OFFSET_X, 0))
		heartCount += 1

func _setHeart(index, state):
		get_child(index).set_frame(state)
		
	
		
