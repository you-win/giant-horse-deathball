class_name BaseUnit
extends RigidBody2D

export var damage: float = 1.0

onready var animation_player: AnimationPlayer = $AnimationPlayer

#var death_ball: DeathBall
#
#var is_under_player_control: bool = false

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready():
	animation_player.play("Available")
	
	connect("body_entered", self, "_on_body_entered")

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	var c = state.get_contact_count()
	if c > 0:
		print(self.name)
		print(c)

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Groups.Group.ENEMY):
		body.receive_damage()

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################
