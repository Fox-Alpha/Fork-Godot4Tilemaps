class_name BuildingBaseResource
extends Resource

@export var BuildingName : String = "BUILDINGBASE"
@export var ImagePath : String = "uid://be7jn2qbcr2wh"
@export_category("Building Preview")
@export var TilesetTileSize : int = 16
@export var TilesetSource : int = 6
@export var TilesetAtlasCoordnates : Vector2i =  Vector2i(0, 0)
@export var TilesetSizeInAtlas : Vector2i = Vector2i(6, 6)

@export var health: int
@export var BuildingImage: Texture2D


# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init():
	pass
