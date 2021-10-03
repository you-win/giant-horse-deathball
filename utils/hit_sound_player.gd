class_name HitSoundPlayer
extends Node

onready var asp_1: AudioStreamPlayer = $AudioStreamPlayer
onready var asp_2: AudioStreamPlayer = $AudioStreamPlayer2
onready var asp_3: AudioStreamPlayer = $AudioStreamPlayer3

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
		3:
			asp_3.stop()
	
	last_played_sound = int(round(rand_range(1, 3)))
	
	match last_played_sound:
		1:
			asp_1.play()
		2:
			asp_2.play()
		3:
			asp_3.play()
