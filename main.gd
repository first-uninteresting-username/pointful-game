extends Node2D

@export var MAX_DIS: float = 50

var score: float = 10
var sec: float = 0
var time: float = 0

const POINT_SCENE = preload("res://point.tscn")

func _process(delta: float) -> void:
	time = time + delta
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
			if a.get_center().distance_squared_to(b.get_center()) < reach * reach:
				if a.get_radius() < MAX_DIS or b.get_radius() < MAX_DIS:
					a.remove_self()
					b.remove_self()
				score = score + calculate_penalty(
					a.get_center().distance_to(b.get_center())
				)
				a.remove_self()
				b.remove_self()

	print(score)

func calculate_delay() -> float:
	return min(1, 15/(time**1.3))


func calculate_penalty(d: float) -> float:
	d = d - 4 * MAX_DIS
	if d < 0:
		return -1
	return min(-1, -d/MAX_DIS)

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
		var rad_plus: float = (point.get_radius() + MAX_DIS)**2
		if p.distance_squared_to(pos) < rad_plus:
			return Vector2.INF
	return p
