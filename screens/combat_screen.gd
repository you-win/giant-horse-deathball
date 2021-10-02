extends Node2D

const CAMERA_SCROLL_SPEED: float = 20.0

onready var camera: Camera2D = $Camera2D
onready var viewport: Viewport = get_viewport()

var last_mouse_position := Vector2.ZERO

# TODO stub
var combat_data

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("secondary"):
		last_mouse_position = viewport.get_mouse_position()
	elif Input.is_action_pressed("secondary"):
		var current_mouse_position = viewport.get_mouse_position()
		
		# TODO add momentum
		camera.translate((last_mouse_position - current_mouse_position).normalized() * CAMERA_SCROLL_SPEED)
		
		last_mouse_position = current_mouse_position

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
