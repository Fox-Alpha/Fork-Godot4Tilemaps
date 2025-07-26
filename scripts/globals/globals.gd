## Hallo Welt
#class_name Globals 
extends Node

## Globale Mouse Position
@onready var GlobalMousePosition : Vector2i = Vector2i.ZERO
## Globale Player Position
@onready var GlobalPlayerPosition : Vector2i = Vector2i.ZERO
@onready var astarpath : Array[Vector2i] = []

var BuildingToPlace : Node = null

# TODO: Getter / Setter
# Invalidate BuildingToPlace, if false
var BuildingMode : bool = false

const BARRACKS = preload("uid://dijgpdkai6m20")
const COMMAND_CENTER = preload("uid://c8q5s3mdfbhp0")
const RADAR = preload("uid://dryt1143aijbt")
const REFINERY = preload("uid://bm40tsnfhlvxc")
const POWERPLANT = preload("uid://soue6jtn4lpw")

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
				BuildingToPlace = COMMAND_CENTER.instantiate()
			KEY_2:
				print("Key 2 verwendet: Powerplant")
				BuildingToPlace = POWERPLANT.instantiate()
			KEY_3:
				print("Key 3 verwendet: Refinery")
				BuildingToPlace = REFINERY.instantiate()
			KEY_4:
				print("Key 4 verwendet: Barracks")
				BuildingToPlace = BARRACKS.instantiate()
			KEY_5:
				print("Key 5 verwendet: Radar")
				BuildingToPlace = RADAR.instantiate()
			KEY_ESCAPE:
				BuildingToPlace.queue_free()
				
		BuildingMode = is_instance_valid(BuildingToPlace)
		pass
		
