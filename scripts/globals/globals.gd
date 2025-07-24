## Hallo Welt
class_name Globals extends Node

## Globale Mouse Position
@onready var GlobalMousePosition : Vector2 = Vector2.ZERO

## Referenz auf den Globalen Signal Bus
var GSB : GlobalSignalBus


func _init() -> void:
	print("Globals => _init()")
	GSB = GlobalSignalBus.new()


func _ready() -> void:
	print("Globals => _ready()")
