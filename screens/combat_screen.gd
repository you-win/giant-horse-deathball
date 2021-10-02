extends Node2D

const CAMERA_SCROLL_SPEED: float = 20.0
const CAMERA_ZOOM_AMOUNT: Vector2 = Vector2(0.1, 0.1)

onready var camera: Camera2D = $Camera2D
onready var viewport: Viewport = get_viewport()
onready var color_rect: ColorRect = $Background/ColorRect

onready var initial_camera_zoom: Vector2 = camera.zoom

var last_mouse_position := Vector2.ZERO

onready var death_ball: DeathBall = $DeathBall

# TODO stub
var scenario: BaseScenario

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	_setup_from_combat_data()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("secondary"):
		last_mouse_position = viewport.get_mouse_position()
	elif Input.is_action_pressed("secondary"):
		var current_mouse_position = viewport.get_mouse_position()
		
		# TODO add momentum
		camera.translate((last_mouse_position - current_mouse_position).normalized() * CAMERA_SCROLL_SPEED)
		
		last_mouse_position = current_mouse_position

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		camera.zoom -= CAMERA_ZOOM_AMOUNT
		if camera.zoom.x < 0.3:
			camera.zoom.x = 0.3
			camera.zoom.y = 0.3
	elif event.is_action_pressed("zoom_out"):
		camera.zoom += CAMERA_ZOOM_AMOUNT
	elif event.is_action_pressed("middle_click"):
		camera.zoom = initial_camera_zoom
		camera.global_position = death_ball.global_position

###############################################################################
# Connections                                                                 #
###############################################################################

###############################################################################
# Private functions                                                           #
###############################################################################

func _setup_from_combat_data() -> void:
	
	pass

###############################################################################
# Public functions                                                            #
###############################################################################
