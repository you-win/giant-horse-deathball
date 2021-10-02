class_name BaseBuilding
extends StaticBody2D

const KILL_TWEEN: float = 1.0

onready var kill_tween: Tween = $KillTween

var health: float = 10.0

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready():
	kill_tween.interpolate_property($Sprite, "modulate:a", 1.0, 0.0, KILL_TWEEN)
	kill_tween.connect("tween_all_completed", self, "_on_kill_tween_complete")

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_kill_tween_complete() -> void:
	queue_free()

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################

func receive_damage(damage: float) -> void:
	health -= damage
	
	if health <= 0:
		kill_tween.start()
