class_name BaseUnit
extends RigidBody2D

export var damage: float = 1.0

onready var animation_player: AnimationPlayer = $AnimationPlayer

var initial_position := Vector2.ZERO

var death_ball: DeathBall
#
#var is_under_player_control: bool = false

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready():
	animation_player.play("Available")
	
	if initial_position != Vector2.ZERO:
		global_position = initial_position

###############################################################################
# Connections                                                                 #
###############################################################################

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################
