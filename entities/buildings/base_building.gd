class_name BaseBuilding
extends StaticBody2D

const KILL_TWEEN: float = 1.0

onready var kill_tween: Tween = $KillTween
onready var health_bar: ProgressBar = $HealthBar

export var health: float = 10.0

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready():
#	kill_tween.interpolate_property($Sprite, "modulate:a", 1.0, 0.0, KILL_TWEEN)
	kill_tween.interpolate_property(self, "modulate:a", 1.0, 0.0, KILL_TWEEN)
	kill_tween.connect("tween_all_completed", self, "_on_kill_tween_complete")
	
	$Hurtbox.connect("body_entered", self, "_on_body_entered")
	
	health_bar.max_value = health
	health_bar.value = health

func _process(delta: float) -> void:
	if health_bar.modulate.a > 0.0:
		health_bar.modulate.a -= delta / 5

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_kill_tween_complete() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Groups.Group.PLAYER):
		receive_damage(body.damage)

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################

func receive_damage(damage: float) -> void:
	health -= damage
	health_bar.value = health
	health_bar.modulate.a = 1.0
	
	if health <= 0:
		kill_tween.start()
