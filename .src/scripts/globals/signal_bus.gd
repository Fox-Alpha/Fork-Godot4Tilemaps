## Globale Signalsammlung, persistent
class_name GlobalSignalBus extends Node

## Ausgelöst wenn die Kartegernerierung beendet ist
signal WORLD_GENERATED

## Ausgelöst wenn der Spieler auf dem Spielfeld platziert wurde
signal PLAYER_RESPAWNED

## 
signal BUILDMODE_REQUESTED(requestedbuilding : Dictionary)
signal BUILDMODE_ENTER
signal BUILDMODE_LEAVED

signal BUILDMODE_STRUCTURE_PLACED(structure_iid : int, MousePos : Vector2i)
signal BUILDMODE_PLACEMENT_POSSIBLE(possible : bool)

func _ready() -> void:
	print("GlobalSignalBus => _ready()")

	WORLD_GENERATED.connect(func(): pass )
	PLAYER_RESPAWNED.connect(func(): pass )
	BUILDMODE_ENTER.connect(func(): pass )
	BUILDMODE_LEAVED.connect(func(): pass )
	BUILDMODE_REQUESTED.connect(func(): pass )
	BUILDMODE_PLACEMENT_POSSIBLE.connect(func(): pass )
	BUILDMODE_STRUCTURE_PLACED.connect(func(): pass )
