class_name BaseBuilding
extends StaticBody2D

const SPAWNABLE_UNITS: Array = [
	preload("res://entities/player/brown_horse.tscn"),
	preload("res://entities/player/cat.tscn"),
	preload("res://entities/player/dog.tscn"),
	preload("res://entities/player/kuma.tscn"),
	preload("res://entities/player/loaf.tscn"),
	preload("res://entities/player/mouse.tscn"),
	preload("res://entities/player/poop_emoji.tscn"),
	preload("res://entities/player/rabbit.tscn"),
	preload("res://entities/player/rubber_duck.tscn"),
	preload("res://entities/player/snail.tscn"),
	preload("res://entities/player/snake.tscn"),
	preload("res://entities/player/turtle.tscn"),
	preload("res://entities/player/white_duck.tscn")
]

const KILL_TWEEN: float = 1.0

onready var kill_tween: Tween = $KillTween
onready var health_bar: ProgressBar = $HealthBar

export var health: float = 10.0
export var flip_sprite: bool = false

export var unit_spawn_count: int = 1
export(Array, PackedScene) var units_to_spawn: Array = []

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready():
	kill_tween.interpolate_property(self, "modulate:a", 1.0, 0.0, KILL_TWEEN)
	kill_tween.connect("tween_all_completed", self, "_on_kill_tween_complete")
	
	$Hurtbox.connect("body_entered", self, "_on_body_entered")
	
	health_bar.max_value = health
	health_bar.value = health
	
	$Sprite.flip_h = flip_sprite

func _process(delta: float) -> void:
	if health_bar.modulate.a > 0.0:
		health_bar.modulate.a -= delta / 5

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_kill_tween_complete() -> void:
	for i in units_to_spawn:
		unit_spawn_count -= 1
		var unit: BaseUnit = i.instance()
		unit.initial_position = global_position
		unit.initial_position.x += rand_range(-10, 10)
		unit.initial_position.y += rand_range(-10, 10)
		get_parent().call_deferred("add_child", unit)
	
	while unit_spawn_count > 0:
		unit_spawn_count -= 1
		var unit: BaseUnit = SPAWNABLE_UNITS[round(rand_range(0, SPAWNABLE_UNITS.size() - 1))].instance()
		unit.initial_position = global_position
		unit.initial_position.x += rand_range(-10, 10)
		unit.initial_position.y += rand_range(-10, 10)
		get_parent().call_deferred("add_child", unit)
	
	queue_free()
	SignalBroadcaster.emit_signal("building_destroyed")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Groups.Group.PLAYER):
		receive_damage(body.damage)
		body.add_hit_effect()

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
		SignalBroadcaster.emit_signal("killed")
	else:
		SignalBroadcaster.emit_signal("hit")
