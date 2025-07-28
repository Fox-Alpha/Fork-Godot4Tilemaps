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


func _ready():	
	GlobalVars.GSB.World_Generated.connect(ResetCamMinimapBorderLimits)
	await RenderingServer.frame_post_draw
	
	vpsize = vp.get_visible_rect().size
	gamecam = vp.get_camera_2d()
	cam2dmap.position = gamecam.global_position
	currcam = gamecam
	sub_viewport.world_2d = vp.world_2d
	minimap.texture = sub_viewport.get_texture()


func _process(_delta):
	var campos = vp.get_camera_2d().global_position
	cam2dmap.global_position = campos


func _input(_event):
	if Input.is_action_just_pressed("SwitchFullScreenMap"):
		pass


func ResetCamMinimapBorderLimits(maprect, _layer):
	cam2dmap.limit_top = 0
	cam2dmap.limit_left = 0
	cam2dmap.limit_bottom = maprect.y
	cam2dmap.limit_right = maprect.x
	pass
