extends Node

var performance_score = 0.2

func _ready():
	pass

func update_question_correct(room_type: int):
	var adjustment = 0
	match room_type:
		1:
			AnalyticVariables["easy"]["correct"] += 1
			adjustment = 0.4
		2:
			AnalyticVariables["medium"]["correct"] += 1
			adjustment = 0.75
		3:
			AnalyticVariables["hard"]["correct"] += 1
			adjustment = 1
	performance_score = (performance_score + adjustment) / 2
	
	
func update_question_wrong(room_type: int):
	var adjustment = 0
	match room_type:
		1:
			AnalyticVariables["easy"]["wrong"] += 1
			adjustment = 0
		2:
			AnalyticVariables["medium"]["wrong"] += 1
			adjustment = 0.2
		3:
			AnalyticVariables["hard"]["wrong"] += 1
			adjustment = 0.3
	performance_score = (performance_score + adjustment) / 2

func get_performance_score():
	return performance_score
	
func get_next_difficulty():
	if performance_score <= 0.33:
		return GlobalVariables.RoomEnum.CHALLENGE_ROOM_EASY
	elif performance_score <= 0.67:
		return GlobalVariables.RoomEnum.CHALLENGE_ROOM_MED
	else:
		return GlobalVariables.RoomEnum.CHALLENGE_ROOM_HARD

# connected via signal
func _on_CombatManager_victory_signal(value, difficulty):
	#print("Analytics " + str(difficulty))
	var prevDifficulty = get_next_difficulty()
	if(value):
		update_question_correct(difficulty)
	else:
		update_question_wrong(difficulty)
	var nextDifficulty = get_next_difficulty()
	
	if(prevDifficulty != nextDifficulty):
		get_node("/root/Main/Maze")._difficultyChange(prevDifficulty, nextDifficulty)

	
func _resetAnalytics():
	AnalyticVariables["easy"]["correct"] += 1
	AnalyticVariables["easy"]["wrong"] += 1
	
	AnalyticVariables["medium"]["correct"] += 1
	AnalyticVariables["medium"]["wrong"] += 1
	
	AnalyticVariables["hard"]["correct"] += 1
	AnalyticVariables["hard"]["wrong"] += 1
	
