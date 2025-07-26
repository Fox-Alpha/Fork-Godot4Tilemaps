## Hallo Welt
#class_name Globals 
extends Node

#region GameStates
enum GameStates {
	NOTDEFINED,
	GAMELOADINGERROR,
	MAINMENU,
	GAMEISLOADING,
	GAMEINITIALIZING,
	GAMEINITIALIZED,
	GAMEWAITFORSTART,
	GAMEISSTARTED,
	GAMEOVER,
}
var GameState : GameStates = GameStates.NOTDEFINED
#endregion

signal Game_Window_Size_Changed
signal Game_State_Changed(gs : GameStates)


## Globale Mouse Position
@onready var GlobalMousePosition : Vector2i = Vector2i.ZERO
## Globale Player Position
@onready var GlobalPlayerPosition : Vector2i = Vector2i.ZERO
@onready var astarpath : Array[Vector2i] = []

var BuildingToPlace : Node = null

# TODO: Getter / Setter
# Invalidate BuildingToPlace, if false
var BuildingMode : bool :
	set(value):
		BuildingMode = value
		if value:
			GSB.Enter_Buildmode.emit()
		else:
			GSB.Leave_Buildmode.emit()
	get: return BuildingMode

const BARRACKS = preload("uid://dijgpdkai6m20")
const COMMAND_CENTER = preload("uid://c8q5s3mdfbhp0")
const RADAR = preload("uid://dryt1143aijbt")
const REFINERY = preload("uid://bm40tsnfhlvxc")
const POWERPLANT = preload("uid://soue6jtn4lpw")

## Referenz auf den Globalen Signal Bus
var GSB : GlobalSignalBus
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()


func _init() -> void:
	print("Globals => _init()")
	GSB = GlobalSignalBus.new()


func _ready() -> void:
	_Connect_Signals()
	print("Globals => _ready()")


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		BuildingMode = checkBuildingKey(event.keyode)
		if BuildingMode:
			GSB.Enter_Buildmode.emit()
		pass


func checkBuildingKey(keycode : Key) -> bool:
	match keycode:
		KEY_1:
			print("Key 1 verwendet: Command Center")
			BuildingToPlace = COMMAND_CENTER.instantiate()
			return false
		KEY_2:
			print("Key 2 verwendet: Powerplant")
			BuildingToPlace = POWERPLANT.instantiate()
			return false
		KEY_3:
			print("Key 3 verwendet: Refinery")
			BuildingToPlace = REFINERY.instantiate()
			return false
		KEY_4:
			print("Key 4 verwendet: Barracks")
			BuildingToPlace = BARRACKS.instantiate()
			return false
		KEY_5:
			print("Key 5 verwendet: Radar")
			BuildingToPlace = RADAR.instantiate()
			return false
		KEY_ESCAPE:
			if not BuildingToPlace.is_queued_for_deletion():
			#if is_instance_valid(BuildingToPlace):
				BuildingToPlace.queue_free()
			return false
		_:
			return false


func _Game_State_Has_Changed(new_gs : GameStates) -> void:
	if GameState == new_gs: return

	GameState = new_gs 
	print("Global Autoload => _Game_State_Has_Changed(GS:%s)" % GameStates.keys()[new_gs])
	match new_gs:
		GameStates.GAMEISLOADING:
			pass
		GameStates.GAMEINITIALIZING:
			pass
		GameStates.GAMEINITIALIZED:
			_Connect_Signals()
			pass
		GameStates.GAMEWAITFORSTART:
			pass
		GameStates.GAMEISSTARTED:
			pass
		GameStates.GAMEOVER:
			#TBD Change Scene to Score Table
			pass


func _Connect_Signals() -> void:
	get_tree().get_root().size_changed.connect(func(): Game_Window_Size_Changed.emit())
	Game_State_Changed.connect(_Game_State_Has_Changed, CONNECT_DEFERRED)
	pass
