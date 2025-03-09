extends Control

var gamecam : Camera2D
var currcam : Camera2D

var fullscreenmapactive : bool = false
var gamecamposition : Vector2i

@onready var minimap := $TextureRectMinimap
@onready var cam2dmap : Camera2D = $SubViewport/Camera2DMinimap
@onready var sub_viewport: SubViewport = $SubViewport
@onready var vp = get_viewport()
@onready var vpsize : Vector2 = vp.get_visible_rect().size
@onready var tilemap : TileMapLayer = get_tree().current_scene.get_node("TileMap/water")


func _ready():	
	await RenderingServer.frame_post_draw
	vpsize = vp.get_visible_rect().size

	cam2dmap.position = vp.get_visible_rect().get_center()

	gamecam = vp.get_camera_2d()
	gamecamposition = gamecam.global_position
	currcam = gamecam
	print(tilemap.get_used_rect().size * tilemap.tile_set.tile_size)

	sub_viewport.world_2d = vp.world_2d
	sub_viewport.size = vp.size * 1.2
	minimap.texture = sub_viewport.get_texture()


func _process(_delta):
#region Neue Code-Region
	#if fullscreenmapactive:
		##gamecam.global_position = Vector2(0,0) # get_parent().get_node("Ground").global_position
		#vp.size = vp.get_visible_rect().size
		#gamecam.zoom = Vector2(0.575, 0.575)
		#vp.content_scale_size = tilemap.get_used_rect().size * tilemap.tile_set.tile_size
	#else:
		#vp.content_scale_size = vp.get_visible_rect().size
		#vp.size = vp.get_visible_rect().size #vpsize
		#pass
#endregion
	cam2dmap.global_position = vp.get_camera_2d().global_position


func _input(_event):
	if Input.is_action_just_pressed("SwitchFullScreenMap"):
#region Fullscreenmap
		#fullscreenmapactive = !fullscreenmapactive
		#if fullscreenmapactive:
			#gamecamposition = gamecam.global_position
			#gamecam.zoom = Vector2(0.575, 0.575)
			#gamecam.global_position = Vector2(0,0)
		#else:
			#gamecam.zoom = Vector2(1.0, 1.0)
			#gamecam.global_position = gamecamposition
			#gamecam.position
#endregion
		pass
