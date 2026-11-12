extends Node2D

var score: float = 0
var sec: float = 0
const POINT_SCENE = preload("res://point.tscn")

func _process(delta: float) -> void:
	sec = sec + delta
	if sec >= 0.3:
		spawn_point()
		sec = 0

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
		var rad: float = point.get_radius()
		if p.distance_squared_to(pos) < (rad + 50) * (rad + 50):
			return Vector2.INF
	return p
