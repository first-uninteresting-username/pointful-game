extends Node
## Autoload (singleton) that survives scene changes.
## It carries the result of the last run from the game scene to the menu scene,
## because every node inside a scene is freed when we switch scenes.

const MENU_SCENE := "res://menu.tscn"
const MAIN_SCENE := "res://main.tscn"

var last_time: float = -1.0


func start_game() -> void:
	get_tree().change_scene_to_file(MAIN_SCENE)


func finish_game(time: float) -> void:
	last_time = time
	get_tree().change_scene_to_file(MENU_SCENE)
