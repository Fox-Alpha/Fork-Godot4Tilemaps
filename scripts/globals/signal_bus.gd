## Globale Signalsammlung, persistent
class_name GlobalSignalBus extends Node

## Ausgelöst wenn die Kartegernerierung beendet ist
signal World_Generated

## Ausgelöst wenn der Spieler auf dem Spielfeld platziert wurde
signal PLayer_Respawned

signal Enter_Buildmode
signal Leave_Buildmode

signal Building_Structure_Placed(structure_iid : int, MousePos : Vector2i)

func _ready() -> void:
	print("GlobalSignalBus => _ready()")

	World_Generated.connect(func(): pass )
	PLayer_Respawned.connect(func(): pass )
	Enter_Buildmode.connect(func(): pass )
	Leave_Buildmode.connect(func(): pass )
	Building_Structure_Placed.connect(func(): pass )
