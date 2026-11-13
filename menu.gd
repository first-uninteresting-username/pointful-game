extends Control

@onready var score_label: Label = $VBoxContainer/Score


func _ready() -> void:
	if GameState.last_time >= 0:
		score_label.text = "%.3f s" % GameState.last_time


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("play"):
		GameState.start_game()


func _on_button_pressed() -> void:
	GameState.start_game()


func _on_licenses_pressed() -> void:
	get_tree().change_scene_to_file("res://licenses.tscn")
