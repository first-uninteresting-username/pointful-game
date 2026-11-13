extends Node2D

@export var MAX_DIS: float = 50
@export var HOLD_TO_FINISH: float = 1.0

var score: float = 10
var sec: float = 0
var time: float = 0

var holding: bool = false
var hold_time: float = 0

const POINT_SCENE = preload("res://point.tscn")

func _process(delta: float) -> void:
	time = time + delta

	if Input.is_action_just_pressed("play"):
		holding = true
	if holding and Input.is_action_pressed("play"):
		hold_time = hold_time + delta
		if hold_time >= HOLD_TO_FINISH:
			GameState.finish_game(time)
			return
	else:
		holding = false
		hold_time = 0

	sec = sec + delta
	if sec > calculate_delay():
		spawn_point()
		sec = 0

	var points: Array[Node] = get_tree().get_nodes_in_group("points")
	for i in range(len(points) - 1):
		for j in range(i+1, len(points)):
			var a := points[i]
			var b := points[j]
			var reach: float = a.get_radius() + b.get_radius()
			if a.get_center().distance_squared_to(b.get_center()) < reach**2:
				if a.get_radius() < MAX_DIS or b.get_radius() < MAX_DIS:
					a.remove_self()
					b.remove_self()
				score = score + calculate_penalty(
					a.get_center().distance_to(b.get_center())
				)
				a.remove_self()
				b.remove_self()

	if score <= 0:
		GameState.finish_game(time)

func calculate_delay() -> float:
	return min(1, 15/(time**1.3))


func calculate_penalty(d: float) -> float:
	d = d - 4 * MAX_DIS
	if d < 0:
		return -2
	return (-d/MAX_DIS) - 2

func _on_add_score(add: float) -> void:
	score = score + add
	score = snapped(score, 0.01)

func spawn_point() -> void:
	var point := POINT_SCENE.instantiate()
	var spawn_pos := get_free_place()
	if spawn_pos != Vector2.INF:
		point.position = spawn_pos
		add_child(point)
		point.add_score.connect(_on_add_score)

func get_free_place() -> Vector2:
	var screen: Rect2 = get_viewport().get_visible_rect()
	var points: Array[Node] = get_tree().get_nodes_in_group("points")
	var p: Vector2 = screen.position + Vector2(
		randf() * screen.size.x, randf() * screen.size.y
	)
	if len(points) == 0:
		return p
	for point in points:
		var pos: Vector2 = point.get_center()
		var rad_plus: float = (point.get_radius() + MAX_DIS * 2)**2
		if p.distance_squared_to(pos) < rad_plus:
			return Vector2.INF
	return p
