extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _initShop():
	var itemType = 1
	for i in get_child_count():
		get_child(i)._setItem(itemType)
