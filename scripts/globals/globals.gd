## Hallo Welt
class_name Globals extends Node

## Globale Mouse Position
@onready var GlobalMousePosition : Vector2i = Vector2i.ZERO
@onready var GlobalPlayerPosition : Vector2i = Vector2i.ZERO
@onready var astarpath : Array[Vector2i] = []

## Referenz auf den Globalen Signal Bus
var GSB : GlobalSignalBus


func _init() -> void:
	print("Globals => _init()")
	GSB = GlobalSignalBus.new()


func _ready() -> void:
	print("Globals => _ready()")


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
