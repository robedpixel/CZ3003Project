extends Node


onready var heartObj = preload("res://Scenes/Prefabs/Heart.tscn")

var heartCount = 0
var HEARTUI_OFFSET_X = 50

var maxHearts = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#_initHeartUI(3)
	#_setHeart(2, 4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _initHeartUI(maxHearts):
	_deleteHeartUI()
	_createHeartUI(maxHearts)
	
func _deleteHeartUI():
	for n in get_children():
		n.queue_free()

func _createHeartUI(noOfHearts):
	for i in noOfHearts:
		var heartInstance = heartObj.instance()
		add_child(heartInstance)
		heartInstance.set_position(Vector2(heartCount * HEARTUI_OFFSET_X, 0))
		heartCount += 1

# frame 4 empty
# frame 0 full
func _setHeartUI(child, state):
	get_child(child).set_frame(state)
	
func _setHeartUIFull(childIndex):
	get_child(childIndex).set_frame(0)
	
func _setHeartUIEmpty(childIndex):
	get_child(childIndex).set_frame(4)
		
func _setHeart(currentHearts, maxHearts):
	var childIndex = 0
	for x in range(currentHearts):
		_setHeartUIFull(childIndex)
		childIndex += 1
	for y in range(currentHearts, maxHearts):
		_setHeartUIEmpty(childIndex)
		childIndex += 1
		
	
		
