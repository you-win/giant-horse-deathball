class_name KillSoundPlayer
extends Node

onready var asp_1: AudioStreamPlayer = $AudioStreamPlayer
onready var asp_2: AudioStreamPlayer = $AudioStreamPlayer2

var last_played_sound: int = 0

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

func play_sound() -> void:
	match last_played_sound:
		1:
			asp_1.stop()
		2:
			asp_2.stop()
	
	last_played_sound = int(round(rand_range(1, 2)))
	
	match last_played_sound:
		1:
			asp_1.play()
		2:
			asp_2.play()
