extends Node

const FADE_TIME: float = 1.0

onready var tween: Tween = $Tween
onready var title: AudioStreamPlayer = $Title
onready var combat: AudioStreamPlayer = $Combat
onready var boss: AudioStreamPlayer = $Boss
onready var level_select: AudioStreamPlayer = $LevelSelect
onready var you_win: AudioStreamPlayer = $YouWin

var current_track: AudioStreamPlayer
var next_track: AudioStreamPlayer

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready():
	tween.connect("tween_all_completed", self, "_on_tween_complete")
	
	current_track = title
	current_track.play(0.0)

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_tween_complete() -> void:
	current_track.stop()
	
	current_track = next_track

###############################################################################
# Private functions                                                           #
###############################################################################

func _play_track(asp: AudioStreamPlayer) -> void:
	if current_track == asp:
		if tween.is_active(): # If the tween is still fading tracks, don't exit early
			tween.stop_all()
			current_track.stop()
			next_track.stop()
		else:
			return
	
	next_track = asp
	
	tween.interpolate_property(current_track, "volume_db", 0.0, -20.0, FADE_TIME)
	tween.interpolate_property(next_track, "volume_db", -20.0, 0.0, FADE_TIME)
	
	next_track.play()
	
	tween.start()

###############################################################################
# Public functions                                                            #
###############################################################################

func play_title() -> void:
	_play_track(title)

func play_combat() -> void:
	_play_track(combat)

func play_boss() -> void:
	_play_track(boss)

func play_level_select() -> void:
	_play_track(level_select)

func play_you_win() -> void:
	_play_track(you_win)
