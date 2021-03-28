extends Node


onready var label = $Label

var coins = 0

var coinToAddCounter = 0

var delay = 0.3
var delayTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(coinToAddCounter > 0):
		delayTimer += delta
		if(delayTimer >= 0.1):
			delayTimer = 0
			$CoinAudio.play()
			coins += 1
			coinToAddCounter -= 1
			_updateLabel()


func _on_Player_coin_change_signal(value):
	pass
	
func _plusCoinCounterUI():
	coinToAddCounter += 1
	
func _updateLabel():
	label.text = str(coins)
