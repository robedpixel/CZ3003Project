extends ColorRect

signal fade_finish

func fade_in():
	print("Fading")
	$AnimationPlayer.play("fadein")

func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("fade_finish")
