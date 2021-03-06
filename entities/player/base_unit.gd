class_name BaseUnit
extends RigidBody2D

const HitEffect: PackedScene = preload("res://entities/hit_effect.tscn")

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

func add_hit_effect() -> void:
	var hit_effect = HitEffect.instance()
	hit_effect.initial_position = global_position
	
	get_parent().call_deferred("add_child", hit_effect)
