extends Node

onready var maze = get_node("/root").get_node("Main/Maze")

var items

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _initShop():
	var items = maze.shopItems
	var itemCost = [5, 10, 15]
	
	for x in 3:
		get_child(x)._hideItem()
	
	for i in items.size():
		if(i in maze.boughtHistory):
			continue
		
		get_child(i)._setItem(items[i], i)
		get_child(i)._showItem()
		
		# TODO CHange cost to its respective cost
		get_child(i)._setItemCost(itemCost[i])
	
