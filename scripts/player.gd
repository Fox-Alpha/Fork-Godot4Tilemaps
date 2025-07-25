extends CharacterBody2D

@export var tile_map_layer : TileMapLayer
enum LAYERS {
	water_layer_0 = 0,
	ground_layer_1 = 1,
	building_layer_2 = 2,
	tree_layer = 3,
	navigation_layer =4
}

@export var SPEED : float = 300.0

@onready var animation_tree = $AnimationTree
var direction : Vector2 = Vector2.ZERO
@onready var pathdir : Vector2 = Vector2i.ZERO
@onready var rng := RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	rng.seed = hash(rng.randi())
	GlobalVars.GSB.World_Generated.connect(ResetPlayerPosition)
	animation_tree.active = true
	tile_map_layer = get_node_or_null("/root/World/LayerGroup").get_children()[LAYERS.navigation_layer] as TileMapLayer
	seed(rng.randi() + rng.randi())

	
func _process(_delta):
	update_animation_parameters()


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		pass

func _physics_process(_delta):
	if GlobalVars.astarpath.size() > 0:
		if global_position.floor() as Vector2i == GlobalVars.astarpath[0] or global_position.distance_to( GlobalVars.astarpath[0]) < 16 :
			GlobalVars.astarpath.pop_front()
		else:
			direction = global_position.direction_to(GlobalVars.astarpath.front())
		pass
	else:
		direction = Input.get_vector("left", "right","up","down").normalized()
		
	if direction:
		velocity = direction * SPEED
		if Input.is_key_pressed(KEY_SHIFT):
			velocity = velocity * 2.5
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	GlobalVars.GlobalPlayerPosition = global_position
	pass


func update_animation_parameters():
	if(velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/is_idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true

	if direction != Vector2.ZERO:
		animation_tree["parameters/idle/blend_position"] = direction
		animation_tree["parameters/walk/blend_position"] = direction


func ResetPlayerPosition(_mapsize, _layer) -> void:
	var tml : TileMapLayer = tile_map_layer
	var newtile := Vector2i.ZERO 
	var nst : Array[Vector2i] = [] 

	var arr : Array = tml.get_empty_cell_positions_in_rect(tml.get_used_rect(), false)

	while nst.size() != 4 and arr.size() > 0:
		newtile = arr[rng.randi_range(0, arr.size())]
		nst = tml.get_surrounding_cells(newtile).filter(filter_not_solid_tiles)

	var gpp  = tml.to_global(tml.map_to_local(newtile))
	global_position = gpp
	
	print("Respawn Player Position %s / %s " % [gpp, newtile])
	GlobalVars.GSB.PLayer_Respawned.emit(gpp)
	pass


func filter_not_solid_tiles(coord : Vector2i) -> bool: 
	var atl_coords = tile_map_layer.get_cell_atlas_coords(coord)
	return atl_coords != Vector2i(11,0)
