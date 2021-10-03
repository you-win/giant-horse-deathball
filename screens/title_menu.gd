extends CanvasLayer

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready():
	$PanelContainer/VBoxContainer/NewGame.connect("pressed", self, "_on_new_game")
	$PanelContainer/VBoxContainer/Quit.connect("pressed", self, "_on_quit")

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_new_game() -> void:
	var new_screen = load("res://screens/combat_screen.tscn").instance()
	new_screen.scenario_path = "res://scenarios/tutorial_scenario.tscn"
#	new_screen.scenario_path = "res://scenarios/final_scenario.tscn"
	AppManager.main.change_screen(new_screen)

func _on_quit() -> void:
	get_tree().quit()

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################
