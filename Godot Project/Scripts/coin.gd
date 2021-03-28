extends Node2D

onready var shakeTween = $ShakeTween
onready var tween = $Tween
onready var childNode = $Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tween_values = [-300.0, 300.0]

var shakeMax
var shakeCount

var setToDespawn : bool = false
var despawnTimer : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(setToDespawn):
		despawnTimer += delta
		if(despawnTimer > 1):
			self.queue_free()

func _playAnim(spawnPos, targetPos):
	var childNode = $ChildNode
	
	set_position(spawnPos)
	
	tween_values = [-20.0, 20.0]
	_setShake(3)
	start_shake_tween()
	
	var randomPos = Vector2(position.x + rand_range(-200, 200), position.y + rand_range(-200, 200))
	tween.interpolate_property(self, "position", get_position(), randomPos, 2.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	
	yield(tween, "tween_completed")
	
	tween.interpolate_property(self, "position", get_position(), targetPos, 1.4, Tween.TRANS_EXPO, Tween.EASE_IN)
	tween.interpolate_property(childNode, "scale", childNode.get_scale(), Vector2(2, 2), 1.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	
	yield(tween, "tween_completed")
	
	get_node("/root/Main/MainCanvas/MainUI/CoinsUI")._plusCoinCounterUI()
	
	setToDespawn = true
	
	self.visible = false


func _setShake(shakeMax):
	shakeCount = 0
	self.shakeMax = shakeMax

func start_shake_tween():
	
	var childNode = $ChildNode
	
	shakeTween.interpolate_property(childNode, "position:y", childNode.get_position().y + tween_values[0] * (2.0/(shakeCount + 1)), childNode.get_position().y + tween_values[1] * (2.0/(shakeCount + 1)), 0.3, Tween.TRANS_QUINT, Tween.EASE_OUT)
	shakeTween.start()	

func _on_ShakeTween_tween_completed(object, key):
	if(shakeCount > shakeMax):
		return
	
	tween_values.invert()
	shakeCount += 1
	
	start_shake_tween()
