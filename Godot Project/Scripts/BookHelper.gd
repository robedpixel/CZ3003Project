extends Node

class_name BookHelper
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var arrayimage = []
var page_number;
var temp_dir;
var temp_file;
# Called when the node enters the scene tree for the first time.
func _ready():
	page_number=-1;
	pass # Replace with function body.
	
func get_next_image() -> Image:
	page_number = (page_number+1)%arrayimage.size()
	return arrayimage[page_number]
	
func read_images_from_folder(path : String):
	temp_dir = Directory.new()
	temp_dir.open(path)
	temp_dir.list_dir_begin()
	
	temp_file = temp_dir.get_next()
	while true:
		var temp_file = temp_dir.get_next()
		if temp_file == "":
			#break the while loop when get_next() returns ""
			break
		elif !temp_file.begins_with("."):
			#get_next() returns a string so this can be used to load the images into an array.
			if temp_file.ends_with(".jpg") or temp_file.ends_with(".png"):
				print(temp_file)
				var img = Image.new()
				img.load(path + temp_file)
				arrayimage.append(img)
	temp_dir.list_dir_end()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
