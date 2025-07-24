extends CharacterBody2D

@export var tile_map_layers : Array[TileMapLayer] = []
enum LAYERS {
	ground_layer_0 = 0,
	ground_layer_1 = 1,
	ground_layer_2 = 2,
	cliff_layer = 3,
	environment_layer =4	
}

@export var SPEED : float = 300.0

@onready var animation_tree = $AnimationTree
var direction : Vector2 = Vector2.ZERO

func _ready():
	GlobalVars.GSB.World_Generated.connect(ResetPlayerPosition)
	animation_tree.active = true

func _process(_delta):
	update_animation_parameters()


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		pass

func _physics_process(_delta):
	direction = Input.get_vector("left", "right","up","down").normalized()
	if direction:
		velocity = direction * SPEED
		if Input.is_key_pressed(KEY_SHIFT):
			velocity = velocity * 2.5
	else:
		velocity = Vector2.ZERO
	move_and_slide()


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


func ResetPlayerPosition(_mapsize, layer) -> void:
	var tml : TileMapLayer = get_node_or_null("/root/World/LayerGroup").get_children(layer)[1] as TileMapLayer
	var newtile := Vector2i.ZERO 
	var nst : Array[Vector2i] = [] 
	var test_tile : Array[Vector2i] = []

	var arr : Array = tml.get_used_cells()

	while test_tile.size() != 4 and arr.size() > 0:
		newtile = arr.pick_random()
		nst = tml.get_surrounding_cells(newtile)
		test_tile = nst.filter(func(coord): 
			var atl_coords = tml.get_cell_atlas_coords(coord)
			return atl_coords != Vector2i(0,1))

	var gpp  = tml.to_global(tml.map_to_local(newtile))
	global_position = gpp
	
	print("Respawn Player Position %s / %s " % [gpp, newtile])
	GlobalVars.GSB.PLayer_Respawned.emit(gpp)
	pass
