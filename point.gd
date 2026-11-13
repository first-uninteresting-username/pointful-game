extends CharacterBody2D

signal add_score(add: float)

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collision_shape.shape = collision_shape.shape.duplicate()

func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		calculate_and_emit_add_score(get_radius())

func calculate_and_emit_add_score(radius: float) -> void:
	var score: float = max(200/radius, 1)
	add_score.emit(score)
	remove_self()

func remove_self() -> void:
	queue_free()

func get_radius() -> float:
	var circle := collision_shape.shape as CircleShape2D
	return circle.radius

func get_center() -> Vector2:
	return collision_shape.global_position
