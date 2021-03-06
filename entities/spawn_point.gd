class_name SpawnPoint
extends Position2D

export var entity: PackedScene

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready():
	var unit = entity.instance()
	unit.initial_position = global_position
	get_parent().call_deferred("add_child", unit)
	queue_free()

###############################################################################
# Connections                                                                 #
###############################################################################

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################
