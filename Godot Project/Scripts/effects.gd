extends Node


var coin = preload("res://Scenes/Prefabs/Coin.tscn")
onready var coinUI = get_node("/root/Main/MainCanvas/MainUI/CoinsUI/Sprite")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _playCoinAnim(spawnPos, numCoins):
	
	for x in numCoins:
		var coinInstance = coin.instance()
		add_child(coinInstance)
		coinInstance._playAnim(spawnPos, coinUI.pos)
