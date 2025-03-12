extends Node2D

@export var worldborders : Array[StaticBody2D] = []

func _ready() -> void:
	GlobalSignalBus.World_Generated.connect(ResetWorldBorderPositions)
	pass


func ResetWorldBorderPositions(maprect : Vector2i) -> void:
	if worldborders.size() != 4:
		return

	worldborders[0].position.x = -(maprect.x / 2.0) + 32	#-2000		#Left	+2Tiles
	worldborders[1].position.y = (-maprect.y / 2.0) +32	#-4400		#Top
	worldborders[2].position.x = (maprect.x / 2.0) - 32	#2000		#Right
	worldborders[3].position.y = (maprect.y / 2.0) -32	#4400		#Bottom
