extends StaticBody2D

@export var BuildingResource : BuildingBaseResource
@onready var collision: CollisionShape2D = $Collision
@onready var image: Sprite2D = $Image


func _ready() -> void:
	#if !is_node_ready():
		#await get_tree().process_frame()
		#await RenderingServer.frame_post_draw
	image.texture = BuildingResource.BuildingImage
	#image.texture = load(BuildingResource.BuildingImage) as Texture2D 
	
	image.region_enabled = true
	image.region_rect.position = Vector2(BuildingResource.TilesetAtlasCoordnates.x * BuildingResource.TilesetTileSize, BuildingResource.TilesetAtlasCoordnates.y * BuildingResource.TilesetTileSize)
	image.region_rect.size = Vector2(BuildingResource.TilesetSizeInAtlas.x * BuildingResource.TilesetTileSize, BuildingResource.TilesetSizeInAtlas.y * BuildingResource.TilesetTileSize)
	
	
	var size_x = BuildingResource.TilesetSizeInAtlas.x
	var size_y = BuildingResource.TilesetSizeInAtlas.y
	var tilesize = BuildingResource.TilesetTileSize
	collision.shape.size = Vector2(size_x * tilesize, size_y * tilesize)
	pass

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
