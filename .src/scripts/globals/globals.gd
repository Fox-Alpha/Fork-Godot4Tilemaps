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


## Referenz auf den Globalen Signal Bus
@onready var GSB : GlobalSignalBus = GlobalSignalBus.new()
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()


func _init() -> void:
	print("Globals => _init()")


func _ready() -> void:
	_Connect_Signals()
	print("Globals => _ready()")


#func _unhandled_key_input(_event: InputEvent) -> void:
	#if event is InputEventKey and event.is_pressed():
	# Maybe Pause Key
	#pass


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
