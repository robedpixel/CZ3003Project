tool
extends CanvasLayer

###########################################################
# Transition List
###########################################################
var transition_list : Array = [
	"transition-hbars.png",
	"transition-vbars.png",
	"transition-mechadoor.png",
	"transition-noise.png",
	"transition-motion.png",
	"transition-motion-pixel.png",
	"transition-swirl.png",
	"transition-pixel-swirl.png",
	"transition-pixel.png",
	"transition-slashes.png",
	"transition-stripes.png",
	"transition-grid.png"
]

enum Transitions {
	bars_x,
	bars_y,
	mecha_door,
	noise,
	motion,
	motion_pixel,
	swirl,
	pixel_swirl_2,
	pixel_swirl,
	slashes,
	stripes,
	grid
}

###########################################################
# Attributes and Logic
###########################################################
export(Transitions) var mask : int = 0 setget _set_mask
export(float, 0.0, 1.0) var fill : float = 0 setget _set_fill
export(float, 0.0, 3.0, 0.1) var duration : float = 1 setget _set_duration

var input_lock : bool = false

onready var tex_rect : TextureRect = $TextureRect
onready var customTransition = $CustomTransitionTextureRect

###########################################################
# Every Frame
###########################################################
func _ready():
	self.mask = mask
	self.fill = fill
	self.duration = duration
	randomize()
	tex_rect.connect("transitionShowStartSignal", get_node("/root/Main/CombatManager"), "_onTransitionShowStart")
	tex_rect.connect("transitionShowEndSignal", get_node("/root/Main/CombatManager"), "_onTransitionShowEnd")

func _process(delta):
	if Engine.editor_hint:
		print("hint")
		set_process(false)
#	else:
#		if Input.is_action_pressed("ui_accept"):
#			tex_rect.hide_screen()
#		elif Input.is_action_pressed("ui_cancel"):
#			tex_rect.show_screen()

###########################################################
# Set Get
###########################################################
func _set_mask(transition_mask:int):
	var new_mask : Texture = load(
		"res://Scenes/transition/transition-imgs/%s" %
		transition_list[transition_mask])
	if new_mask:
		mask = transition_mask
		if Engine.editor_hint:
			$TextureRect.texture = new_mask
		elif tex_rect:
			tex_rect.texture = new_mask

func _set_fill(val:float):
	fill = val
	if Engine.editor_hint:
		$TextureRect.fill = val
	elif tex_rect:
		tex_rect.fill = val

func _set_duration(val:float):
	duration = val
	if Engine.editor_hint:
		$TextureRect.duration = val
	elif tex_rect:
		tex_rect.duration = val

func _roomFlash():
	customTransition._setColor(Color(0.7, 0.7, 0.7, 1.0))
	customTransition._startTransition(0.5, Tween.TRANS_QUINT, Tween.EASE_OUT, Tween.TRANS_QUINT, Tween.EASE_IN)
	
func _hurtFlash():
	customTransition._setColor(Color(0.8, 0, 0.16, 0.7))
	customTransition._startTransition(0.15, Tween.TRANS_LINEAR, Tween.EASE_IN, Tween.TRANS_LINEAR, Tween.EASE_IN)

func _on_CombatManager_combat_signal(value):
	if(value):
		_set_mask(randi() % 12)
		tex_rect.setImmediateShow()
		tex_rect.hide_screen()

func _onPlayerHurtSignal(value):
	_hurtFlash()
