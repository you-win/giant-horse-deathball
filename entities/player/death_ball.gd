class_name DeathBall
extends Node2D

const UNIT_SPEED: float = 10.0

onready var sprite: Sprite = $Sprite
var sprite_transparency: float = 0.0

onready var area: Area2D = $Area2D

var units_in_area: Array = []

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	sprite_transparency = sprite.modulate.a
	
	area.connect("body_entered", self, "_on_body_entered")
#	area.connect("body_exited", self, "_on_body_exited")

func _physics_process(delta: float) -> void:
	sprite.modulate.a = lerp(sprite.modulate.a, 0.0, 0.25)
	
	if Input.is_action_pressed("primary"):
		global_position = get_global_mouse_position()
		sprite.modulate.a = sprite_transparency
	
	for unit in units_in_area:
		unit.apply_central_impulse((global_position - unit.global_position).normalized() * UNIT_SPEED)
#		unit.linear_velocity = unit.linear_velocity.clamped(100)

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Groups.Group.PLAYER):
		if not units_in_area.has(body):
			units_in_area.append(body)
			body.animation_player.play("RESET")

func _on_body_exited(body: Node) -> void:
	if body.is_in_group(Groups.Group.PLAYER):
		units_in_area.erase(body)

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################
