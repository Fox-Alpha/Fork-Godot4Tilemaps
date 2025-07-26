extends Node2D

@onready var build_ghost: Sprite2D = get_node_or_null("BuildGhost")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.GSB.Enter_Buildmode.connect(EnterBuildMode)
	GlobalVars.GSB.Leave_Buildmode.connect(LeaveBuildMode)
	pass # Replace with function body.


func _process(_delta: float) -> void:
	HandleBuildMode()
	pass


func EnterBuildMode() -> void:
	if GlobalVars.BuildingMode and is_instance_valid(GlobalVars.BuildingToPlace):
		var BuildImage : Texture2D = GlobalVars.BuildingToPlace.get_node("Picture").texture
		build_ghost.texture = BuildImage as Texture2D
	pass

func LeaveBuildMode() -> void:
	build_ghost.texture = null
	pass


func HandleBuildMode():
	if GlobalVars.BuildingMode and is_instance_valid(GlobalVars.BuildingToPlace):
		global_position = GlobalVars.GlobalMousePosition
		pass
