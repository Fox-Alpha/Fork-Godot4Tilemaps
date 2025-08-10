class_name BuildingBaseResource
extends Resource

@export var BuildingName : String = "BUILDINGBASE"
@export var ImagePath : String = "uid://jbkrspyqk1oo"
@export_category("Building Preview")
@export var TilesetTileSize : int = 16
@export var TilesetSource : int = 6
@export var TilesetAtlasCoordnates : Vector2i =  Vector2i(22, 12)
@export var TilesetSizeInAtlas : Vector2i = Vector2i(8, 8)

@export var health: int
@export var BuildingImage: Texture2D


# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init():
	pass
