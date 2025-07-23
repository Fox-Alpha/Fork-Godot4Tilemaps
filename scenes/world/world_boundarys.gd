extends Node2D

@export_group("Borders")
@export var LeftBorder : StaticBody2D
@export var TopBorder : StaticBody2D
@export var RightBorder : StaticBody2D
@export var BottomBorder : StaticBody2D

func _ready() -> void:
	GlobalSignalBus.World_Generated.connect(ResetWorldBorderPositions)
	pass


func ResetWorldBorderPositions(maprect : Vector2i, _l) -> void:
	print("ResetWorldBorderPositions: %s" % [maprect])

	LeftBorder.position.x = 0 #-(maprect.x / 2.0)	#-2000		#Left	+2Tiles
	TopBorder.position.y = 0 #(-maprect.y / 2.0)	#-4400		#Top
	RightBorder.position.x = maprect.x #(maprect.x / 2.0) 	#2000		#Right
	BottomBorder.position.y = maprect.y #(maprect.y / 2.0) 	#4400		#Bottom
	pass
