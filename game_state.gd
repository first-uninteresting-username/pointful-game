extends Node

const MENU_SCENE := "res://menu.tscn"
const MAIN_SCENE := "res://main.tscn"

var last_time: float = -1.0


func start_game() -> void:
	get_tree().change_scene_to_file(MAIN_SCENE)


func finish_game(time: float) -> void:
	last_time = time
	get_tree().change_scene_to_file(MENU_SCENE)
