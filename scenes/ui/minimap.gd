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
@onready var gaea_generator: GaeaGenerator = $/root/World/GAEA_World/GaeaGenerator
#@onready var tilemap : Vector3i = get_tree().current_scene.get_node("GAEA_World/GaeaGenerator")


func _ready():	
	GlobalVars.GSB.World_Generated.connect(ResetCamMinimapBorderLimits)
	await RenderingServer.frame_post_draw
	
	vpsize = vp.get_visible_rect().size

	#cam2dmap.position = vp.get_visible_rect().get_center()

	gamecam = vp.get_camera_2d()
	#gamecamposition = gamecam.global_position
	cam2dmap.position = gamecam.global_position
	currcam = gamecam
	#print(tilemap.get_used_rect().size * tilemap.tile_set.tile_size)

	sub_viewport.world_2d = vp.world_2d
	#sub_viewport.size = vp.size #* 1.2
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
	var campos = vp.get_camera_2d().global_position
	cam2dmap.global_position = campos


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


func ResetCamMinimapBorderLimits(maprect, _layer):
	#var vpcam := get_viewport().get_camera_2d()
	cam2dmap.limit_top = 0 # -maprect.y / 2	#-2000
	cam2dmap.limit_left = 0 # -maprect.x / 2	#-4400
	cam2dmap.limit_bottom = maprect.y # / 2	#2000
	cam2dmap.limit_right = maprect.x # / 2	#4400
	pass
