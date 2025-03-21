extends Node2D

@export var worldborders : Array[StaticBody2D] = []

func _ready() -> void:
	GlobalSignalBus.World_Generated.connect(ResetWorldBorderPositions)
	pass


func ResetWorldBorderPositions(maprect : Vector2i, _l) -> void:
	if worldborders.size() != 4:
		return

	worldborders[0].position.x = 0 #-(maprect.x / 2.0)	#-2000		#Left	+2Tiles
	worldborders[1].position.y = 0 #(-maprect.y / 2.0)	#-4400		#Top
	worldborders[2].position.x = maprect.x #(maprect.x / 2.0) 	#2000		#Right
	worldborders[3].position.y = maprect.y #(maprect.y / 2.0) 	#4400		#Bottom
	pass
