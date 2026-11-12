extends Node2D

@onready var score_label: Label = $HUD/ScoreLabel

var score: float = 0

func add_score(add: float) -> void:
	score = score + add
	score_label.text = "Score: " + str(score)
