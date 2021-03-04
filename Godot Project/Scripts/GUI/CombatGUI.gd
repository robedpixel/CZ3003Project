extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var cmbtManager = get_node('../../CombatManager')

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _toggle(show):
	if(show):
		_show()
	else:
		_hide()

func _show():
	self.visible = true

func _hide():
	self.visible = false

func _on_Button1_pressed():
	cmbtManager._onAnswer(1)

func _on_Button2_pressed():
	cmbtManager._onAnswer(2)


func _on_Button3_pressed():
	cmbtManager._onAnswer(3)


func _on_Button4_pressed():
	cmbtManager._onAnswer(4)
