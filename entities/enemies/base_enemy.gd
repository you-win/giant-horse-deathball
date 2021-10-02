class_name BaseEnemy
extends KinematicBody2D

onready var hurtbox: Area2D = $Hurtbox
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var melee_attack: StaticBody2D = $MeleeAttack
onready var capture_attack: Area2D = $CaptureAttack

var initial_position := Vector2.ZERO

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready():
	global_position = initial_position
	
	add_collision_exception_with(melee_attack)
	add_collision_exception_with(capture_attack)

###############################################################################
# Connections                                                                 #
###############################################################################

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################
