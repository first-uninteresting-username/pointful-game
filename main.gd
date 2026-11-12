extends Node2D

@onready var score_label: Label = $HUD/ScoreLabel

var score: float = 0

func _ready() -> void:
	$Point.add_score.connect(_on_add_score)

func _on_add_score(add: float) -> void:
	score = score + add
	score = snapped(score, 0.01)
	score_label.text = "Score: " + str(score)
