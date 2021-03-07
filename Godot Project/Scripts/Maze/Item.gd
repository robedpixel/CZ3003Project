extends Node


enum ItemEnum {ITEM_NULL, ITEM_HEALTHPOT, ITEM_SCROLL}

export var itemType = ItemEnum.ITEM_NULL

onready var itemSprite = $ItemSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _setItem(type):
	itemType = type
	itemSprite.texture = _getImage()

func _getImage():
	match itemType:
		ItemEnum.ITEM_HEALTHPOT:
			return load("res://Resources/images/life-pot.png")
		ItemEnum.ITEM_SCROLL:
			pass
		_:
			return null
