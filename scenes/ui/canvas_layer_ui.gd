extends Label

@onready var ground_tile_layer: TileMapLayer = $"/root/World/LayerGroup/GroundTileLayer"
#@onready var label_mouse_position: Label = $"/root/World/CanvasLayer/LabelMousePosition"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var GlMoPos := get_global_mouse_position()
	var tml : TileMapLayer = ground_tile_layer
	var loc_mouse_coord : Vector2i = tml.local_to_map(GlMoPos)
	text = "Mouse Position in Map: %s" % str(loc_mouse_coord)


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_1:
				print("Key 1 verwendet: Command Center")
			KEY_2:
				print("Key 2 verwendet: Powerplant")
			KEY_3:
				print("Key 3 verwendet: Refinery")
			KEY_4:
				print("Key 4 verwendet: Barracks")
			KEY_5:
				print("Key 5 verwendet: Radar")
