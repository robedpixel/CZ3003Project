extends Node2D

var world1dir = ["res://Resources/images/World1GuideBook/1.jpg", "res://Resources/images/World1GuideBook/2.jpg","res://Resources/images/World1GuideBook/3.jpg",
"res://Resources/images/World1GuideBook/4.jpg","res://Resources/images/World1GuideBook/5.jpg","res://Resources/images/World1GuideBook/6.jpg",
"res://Resources/images/World1GuideBook/7.jpg","res://Resources/images/World1GuideBook/8.jpg","res://Resources/images/World1GuideBook/9.jpg",
"res://Resources/images/World1GuideBook/10.jpg","res://Resources/images/World1GuideBook/11.jpg","res://Resources/images/World1GuideBook/12.jpg",
"res://Resources/images/World1GuideBook/13.jpg","res://Resources/images/World1GuideBook/14.jpg","res://Resources/images/World1GuideBook/15.jpg",
"res://Resources/images/World1GuideBook/16.jpg", "res://Resources/images/World1GuideBook/17.jpg","res://Resources/images/World1GuideBook/18.jpg",
"res://Resources/images/World1GuideBook/19.jpg","res://Resources/images/World1GuideBook/20.jpg","res://Resources/images/World1GuideBook/21.jpg",
"res://Resources/images/World1GuideBook/22.jpg","res://Resources/images/World1GuideBook/23.jpg","res://Resources/images/World1GuideBook/24.jpg",
"res://Resources/images/World1GuideBook/25.jpg","res://Resources/images/World1GuideBook/26.jpg","res://Resources/images/World1GuideBook/27.jpg",
"res://Resources/images/World1GuideBook/28.jpg","res://Resources/images/World1GuideBook/29.jpg","res://Resources/images/World1GuideBook/30.jpg",
"res://Resources/images/World1GuideBook/31.jpg","res://Resources/images/World1GuideBook/32.jpg","res://Resources/images/World1GuideBook/33.jpg",
"res://Resources/images/World1GuideBook/34.jpg","res://Resources/images/World1GuideBook/35.jpg","res://Resources/images/World1GuideBook/36.jpg",
"res://Resources/images/World1GuideBook/37.jpg","res://Resources/images/World1GuideBook/38.jpg","res://Resources/images/World1GuideBook/39.jpg",
"res://Resources/images/World1GuideBook/40.jpg","res://Resources/images/World1GuideBook/41.jpg","res://Resources/images/World1GuideBook/42.jpg",
"res://Resources/images/World1GuideBook/43.jpg","res://Resources/images/World1GuideBook/44.jpg","res://Resources/images/World1GuideBook/45.jpg",
"res://Resources/images/World1GuideBook/46.jpg","res://Resources/images/World1GuideBook/47.jpg","res://Resources/images/World1GuideBook/48.jpg",
"res://Resources/images/World1GuideBook/49.jpg","res://Resources/images/World1GuideBook/50.jpg","res://Resources/images/World1GuideBook/51.jpg",
"res://Resources/images/World1GuideBook/52.jpg","res://Resources/images/World1GuideBook/53.jpg","res://Resources/images/World1GuideBook/54.jpg",
"res://Resources/images/World1GuideBook/55.jpg",
]


var world2dir = ["res://Resources/images/World2GuideBook/1.jpg", "res://Resources/images/World2GuideBook/2.jpg","res://Resources/images/World2GuideBook/3.jpg",
"res://Resources/images/World2GuideBook/4.jpg","res://Resources/images/World2GuideBook/5.jpg","res://Resources/images/World2GuideBook/6.jpg",
"res://Resources/images/World2GuideBook/7.jpg","res://Resources/images/World2GuideBook/8.jpg","res://Resources/images/World2GuideBook/9.jpg",
"res://Resources/images/World2GuideBook/10.jpg","res://Resources/images/World2GuideBook/11.jpg","res://Resources/images/World2GuideBook/12.jpg",
"res://Resources/images/World2GuideBook/13.jpg","res://Resources/images/World2GuideBook/14.jpg","res://Resources/images/World2GuideBook/15.jpg",
"res://Resources/images/World2GuideBook/16.jpg", "res://Resources/images/World2GuideBook/17.jpg","res://Resources/images/World2GuideBook/18.jpg",
"res://Resources/images/World2GuideBook/19.jpg","res://Resources/images/World2GuideBook/20.jpg","res://Resources/images/World2GuideBook/21.jpg",
"res://Resources/images/World2GuideBook/22.jpg","res://Resources/images/World2GuideBook/23.jpg","res://Resources/images/World2GuideBook/24.jpg",
"res://Resources/images/World2GuideBook/25.jpg","res://Resources/images/World2GuideBook/26.jpg","res://Resources/images/World2GuideBook/27.jpg",
"res://Resources/images/World2GuideBook/28.jpg","res://Resources/images/World2GuideBook/29.jpg","res://Resources/images/World2GuideBook/30.jpg",
"res://Resources/images/World2GuideBook/31.jpg","res://Resources/images/World2GuideBook/32.jpg","res://Resources/images/World2GuideBook/33.jpg",
"res://Resources/images/World2GuideBook/34.jpg","res://Resources/images/World2GuideBook/35.jpg","res://Resources/images/World2GuideBook/36.jpg",
"res://Resources/images/World2GuideBook/37.jpg","res://Resources/images/World2GuideBook/38.jpg","res://Resources/images/World2GuideBook/39.jpg",
"res://Resources/images/World2GuideBook/40.jpg","res://Resources/images/World2GuideBook/41.jpg","res://Resources/images/World2GuideBook/42.jpg",
"res://Resources/images/World2GuideBook/43.jpg","res://Resources/images/World2GuideBook/44.jpg","res://Resources/images/World2GuideBook/45.jpg",
"res://Resources/images/World2GuideBook/46.jpg","res://Resources/images/World2GuideBook/47.jpg","res://Resources/images/World2GuideBook/48.jpg",
"res://Resources/images/World2GuideBook/49.jpg","res://Resources/images/World2GuideBook/50.jpg","res://Resources/images/World2GuideBook/51.jpg",
"res://Resources/images/World2GuideBook/52.jpg","res://Resources/images/World2GuideBook/53.jpg","res://Resources/images/World2GuideBook/54.jpg",
"res://Resources/images/World2GuideBook/55.jpg","res://Resources/images/World2GuideBook/56.jpg","res://Resources/images/World2GuideBook/57.jpg"
,"res://Resources/images/World2GuideBook/58.jpg","res://Resources/images/World2GuideBook/59.jpg"
]

var isOpen : bool = false

var defaultPage = 1

func _ready():
	pass # Replace with function body.

	
	
func displaySlide(no):
	if (GlobalVariables.world_num == 1):
		var t = Texture.new()
		t = load(world1dir[no])
		get_node("Popup/ScrollContainer/RichTextLabel").add_image(t,600,400)
		pass
	else:
		var t = Texture.new()
		t = load(world2dir[no])
		get_node("Popup/ScrollContainer/RichTextLabel").add_image(t,600,400)
		pass

func _open():
	if(isOpen):
		return
		
	isOpen = true
	get_node("Popup").popup()
	get_node("Popup/PageNumber").text = str(defaultPage) + " / " + str(world2dir.size())
	displaySlide(defaultPage-1)

func _on_ToolButton_pressed():
	get_node("Popup").popup()
	get_node("Popup/PageNumber").text = str(defaultPage) + " / " + str(world2dir.size())
	displaySlide(defaultPage-1)
	

func _on_PreviousPageButton_pressed():
	if(defaultPage != 1):
		defaultPage -= 1
		get_node("Popup/PageNumber").text = str(defaultPage) + " / " + str(world2dir.size())
		get_node("Popup/ScrollContainer/RichTextLabel").text = ""
		displaySlide(defaultPage-1)


func _on_NextPageButton_pressed():
	if(defaultPage < world1dir.size()):
		defaultPage += 1
		get_node("Popup/PageNumber").text = str(defaultPage) + " / " + str(world2dir.size())
		get_node("Popup/ScrollContainer/RichTextLabel").text = ""
		displaySlide(defaultPage-1)


func _on_Popup_popup_hide():
	isOpen = false
	var player = get_node("/root/Main/Player")
	if(player):
		player._lockCharacter(false)
