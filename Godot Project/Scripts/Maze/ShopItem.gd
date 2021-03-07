extends Node


enum ShopItemEnum {ITEM_NULL, ITEM_HEALTHPOT, ITEM_SCROLL}

export var shopItemType = ShopItemEnum.ITEM_NULL

onready var shopItemSprite = $ShopItemSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _setItem(type):
	shopItemType = type
	shopItemSprite.texture = _getImage()

func _getImage():
	match shopItemType:
		ShopItemEnum.ITEM_HEALTHPOT:
			return load("res://Resources/images/life-pot.png")
		ShopItemEnum.ITEM_SCROLL:
			pass
		_:
			pass
