class_name BaseScenario
extends Node2D

enum Objective { NONE = 0, ENEMY, BUILDING, SAVE, BOSS }
export(Objective) var objective = Objective.NONE
export var objective_count: int = 1

export var background_color: Color = Color(0.23, 0.39, 0.15)

export var score: float = 60.0

###############################################################################
# Builtin functions                                                           #
###############################################################################

###############################################################################
# Connections                                                                 #
###############################################################################

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################
