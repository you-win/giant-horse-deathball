class_name DeathBall
extends Node2D

const UNIT_SPEED: float = 10.0

onready var sprite: Sprite = $Sprite
var sprite_transparency: float = 0.0

onready var area: Area2D = $Area2D

var units: Array = []

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	sprite_transparency = sprite.modulate.a
	
	area.connect("body_entered", self, "_on_body_entered")

func _physics_process(_delta: float) -> void:
	sprite.modulate.a = lerp(sprite.modulate.a, 0.0, 0.25)
	
	if Input.is_action_pressed("primary"):
		global_position = get_global_mouse_position()
		sprite.modulate.a = sprite_transparency
	
	for unit in units:
		# TODO still needs tuning
		# TODO sometimes units are null??? might be the horses sign
		unit.apply_central_impulse((global_position - unit.global_position).normalized() * UNIT_SPEED)

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Groups.Group.PLAYER):
		if not units.has(body):
			units.append(body)
			body.animation_player.play("RESET")
			body.death_ball = self

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################
