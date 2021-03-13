extends Node


enum ItemEnum {ITEM_NULL, ITEM_HEALTHPOT, ITEM_SCROLL}

var itemType
export var itemCost = 1

onready var itemSprite = $ItemSprite
onready var itemLabel = $Label
onready var itemCoinSprite = $ItemCoinSprite
onready var area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _hideItem():
	itemSprite.visible = false
	
	if(itemLabel):
		itemLabel.visible = false
	if(itemCoinSprite):
		itemCoinSprite.visible = false
	
	area2D._disable()

func _showItem():
	itemSprite.visible = true
	
	if(itemLabel):
		itemLabel.visible = true
	if(itemCoinSprite):
		itemCoinSprite.visible = true
		
	area2D._enable()

func _setItem(type):
	itemType = type
	itemSprite.texture = _getImage()

func _setItemCost(cost):
	itemCost = cost
	itemLabel.text = str(itemCost)

func _getImage():
	match itemType:
		ItemEnum.ITEM_HEALTHPOT:
			return load("res://Resources/images/life-pot.png")
		ItemEnum.ITEM_SCROLL:
			pass
		_:
			return null
			
func _interact(player):
	if(player._getCoins() < itemCost):
		print("Not enough money to purchase")
		return
		
	player._removeCoins(itemCost)
	
	player._addItem(itemType)
	
	_hideItem()
	# fuck it just remove item from maze directly
	get_node("/root/Main/Maze").shopItems.erase(itemType)
		
		
