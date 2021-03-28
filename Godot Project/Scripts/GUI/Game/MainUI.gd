extends CanvasItem


onready var maze = get_node("/root/Main/Maze")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CombatManager_combat_signal(value):
	if(value):
		visible = false
		maze._toggleAllDoors(false)
	else:
		visible = true
		maze._refreshRoom()

func _setPlayerDamageLabel(multiplier):
	$DamageUI/Label.text = str(multiplier)
