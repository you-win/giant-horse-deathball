extends Node

onready var hsp_1: HitSoundPlayer = $HitSoundPlayer
onready var hsp_2: HitSoundPlayer = $HitSoundPlayer2
onready var hsp_3: HitSoundPlayer = $HitSoundPlayer3
var next_hsp: int = 1

onready var ksp_1: KillSoundPlayer = $KillSoundPlayer
onready var ksp_2: KillSoundPlayer = $KillSoundPlayer2
var next_ksp: int = 1

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	SignalBroadcaster.connect("hit", self, "_on_hit")
	SignalBroadcaster.connect("killed", self, "_on_killed")

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_hit() -> void:
	match next_hsp:
		1:
			hsp_1.play_sound()
			next_hsp = 2
		2:
			hsp_2.play_sound()
			next_hsp = 3
		3:
			hsp_3.play_sound()
			next_hsp = 1

func _on_killed() -> void:
	match next_ksp:
		1:
			ksp_1.play_sound()
			next_ksp = 2
		2:
			ksp_2.play_sound()
			next_ksp = 1

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################
