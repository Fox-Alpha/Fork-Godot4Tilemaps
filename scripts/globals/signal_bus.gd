## Globale Signalsammlung, persistent
class_name GlobalSignalBus extends Node

## Ausgelöst wenn die Kartegernerierung beendet ist
signal World_Generated

## Ausgelöst wenn der Spieler auf dem Spielfeld platziert wurde
signal PLayer_Respawned


func _ready() -> void:
	print("GlobalSignalBus => _ready()")

	World_Generated.connect(func(): pass )
	PLayer_Respawned.connect(func(): pass )
