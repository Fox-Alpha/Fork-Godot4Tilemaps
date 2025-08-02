## Globale Signalsammlung, persistent
class_name GlobalSignalBus extends Node

## Ausgelöst wenn die Kartegernerierung beendet ist
signal WORLD_GENERATED(_ms:Vector2i, _layer : int)

## Ausgelöst wenn der Spieler auf dem Spielfeld platziert wurde
signal PLAYER_RESPAWNED(_GlobalPlayePosition : Vector2i)

## 
signal BUILDMODE_REQUESTED(requestedbuilding : Dictionary)
signal BUILDMODE_REQUESTED_CHANGED(requestedbuilding : Dictionary)
signal BUILDMODE_ENTERED
signal BUILDMODE_LEAVED

signal BUILDMODE_STRUCTURE_PLACED(structure_iid : int, MousePos : Vector2i)
signal BUILDMODE_PLACEMENT_POSSIBLE(possible : bool)
signal BUILDMODE_ERROR(BUILDMODEERROR : String)


func _init() -> void:
	print("GlobalSignalBus => _init()")
	name = "GlobalSignalBus"


func _ready() -> void:
	print("GlobalSignalBus => _ready()")

	WORLD_GENERATED.connect(func(_ms, _l): pass )
	PLAYER_RESPAWNED.connect(func(_p): pass )
	BUILDMODE_ENTERED.connect(func(): pass )
	BUILDMODE_LEAVED.connect(func(): pass )
	BUILDMODE_REQUESTED.connect(func(): pass )
	BUILDMODE_REQUESTED_CHANGED.connect(func(): pass )
	BUILDMODE_PLACEMENT_POSSIBLE.connect(func(): pass )
	BUILDMODE_STRUCTURE_PLACED.connect(func(): pass )
	BUILDMODE_ERROR.connect(func(): pass )
