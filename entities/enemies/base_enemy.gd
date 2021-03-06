class_name BaseEnemy
extends KinematicBody2D

const HitEffect: PackedScene = preload("res://entities/hit_effect.tscn")

const KILL_TWEEN: float = 1.0
export var launch_speed: float = 500.0

onready var hurtbox: Area2D = $Hurtbox
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var launch_attack: Area2D = $LaunchAttack
onready var detection_range: Area2D = $DetectionRange
onready var kill_tween: Tween = $KillTween
onready var health_bar: ProgressBar = $HealthBar

var initial_position := Vector2.ZERO

var detected_units: Array = []

var new_action_counter: float = 0.0
export var new_action_time: float = 10.0
var is_action_locked := false

export var health: float = 10.0
export var speed: float = 50.0

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready():
	if initial_position != Vector2.ZERO:
		global_position = initial_position
	
	health_bar.max_value = health
	health_bar.value = health
	
	kill_tween.interpolate_property(self, "modulate:a", 1.0, 0.0, KILL_TWEEN)
	kill_tween.connect("tween_all_completed", self, "_on_kill_tween_complete")
	
	hurtbox.connect("body_entered", self, "_on_hurtbox")
	
	anim_player.connect("animation_finished", self, "_on_anim_finished")
	
	detection_range.connect("body_entered", self, "_on_detected")
	detection_range.connect("body_exited", self, "_on_undetected")
	
	launch_attack.connect("body_entered", self, "_on_launch")

func _process(delta: float) -> void:
	if health_bar.modulate.a > 0.0:
		health_bar.modulate.a -= delta / 5
	
	if not is_action_locked:
		new_action_counter += delta
		if new_action_counter >= new_action_time:
			new_action_counter = 0.0
			is_action_locked = true
		
	if detected_units.size() > 0:
		var unit_pos: Vector2 = detected_units[0].global_position
		move_and_slide((unit_pos - global_position).normalized() * speed)
		launch_attack.look_at(unit_pos)
		if is_action_locked:
			anim_player.play("Launch")

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_kill_tween_complete() -> void:
	queue_free()
	SignalBroadcaster.emit_signal("enemy_killed")

func _on_hurtbox(body: Node) -> void:
	if _is_player_unit(body):
		receive_damage(body.damage)
		body.add_hit_effect()

func _on_anim_finished(anim_name: String) -> void:
	if anim_name == "Rest":
		return
	anim_player.play("Rest")
	is_action_locked = false

func _on_detected(body: Node) -> void:
	if _is_player_unit(body):
		if not detected_units.has(body):
			detected_units.append(body)

func _on_undetected(body: Node) -> void:
	if _is_player_unit(body):
		detected_units.erase(body)

func _on_launch(body: Node) -> void:
	if _is_player_unit(body):
		if body.death_ball:
			body.death_ball.units.erase(body)
		body.apply_central_impulse((body.global_position - global_position).normalized() * launch_speed)
		SignalBroadcaster.emit_signal("hit")

###############################################################################
# Private functions                                                           #
###############################################################################

func _is_player_unit(body: Node) -> bool:
	return body.is_in_group(Groups.Group.PLAYER)

###############################################################################
# Public functions                                                            #
###############################################################################

func receive_damage(damage: float) -> void:
	health -= damage
	health_bar.value = health
	health_bar.modulate.a = 1.0
	
	if health <= 0:
		kill_tween.start()
		speed = 0.0
		is_action_locked = true
		SignalBroadcaster.emit_signal("killed")
	else:
		SignalBroadcaster.emit_signal("hit")
