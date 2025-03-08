extends Camera2D

@export var _zoom_step := 0.12
@export var _min_zoom := 0.01
@export var _max_zoom := 3.0

func _ready() -> void:
	pass

func _input(event):
	if event.is_action_pressed("zoom_in"):
		zoom_step(-1)
	if event.is_action_pressed("zoom_out"):
		zoom_step(1)

func zoom_step(zoom_direction : int):
	if zoom_direction != 0:
		zoom = Vector2(clamp(zoom.x + zoom_direction * zoom.x * _zoom_step, _min_zoom, _max_zoom),
			clamp(zoom.y + zoom_direction * zoom.y * _zoom_step, _min_zoom, _max_zoom))
	pass
