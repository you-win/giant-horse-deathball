extends Node2D

const CHAT_MESSAGES = [
	"We need to deal with the animal menance",
	"You must construct additional pylons",
	"Why are my horses so angry",
	"Send help",
	"No",
	"Maybe",
	"Yes... No",
	"Insufficient funds",
	"The animals are everywhere",
	"They destroyed my stable",
	"They turned me into a newt"
]

enum ChatStates {
	NONE = 0,
	ONE,
	TWO,
	THREE,
	SEND
}
var chat_state = ChatStates.ONE

const CHATTER_TIME: float = 1.0
onready var chatter_timer: Timer = $ChatterTimer

onready var dialogue: VBoxContainer = $GUI/Dialogue/ScrollContainer/VBoxContainer
var current_message: Label
var is_left := true

onready var option_1: Button = $GUI/Choices/VBoxContainer/Option1
onready var option_2: Button = $GUI/Choices/VBoxContainer/Option2
onready var option_3: Button = $GUI/Choices/VBoxContainer/Option3

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready():
	$AnimationPlayer.play("Run")
	
	chatter_timer.connect("timeout", self, "_on_chatter")
	chatter_timer.start(CHATTER_TIME)
	
	$GUI/CurrentScore/HBoxContainer/Value.text = "%.2f" % AppManager.player_session_score
	
	var available_levels: Array = [1, 2]
	for key in AppManager.levels_beaten.keys():
		if key in available_levels:
			if AppManager.levels_beaten[key]:
				available_levels.erase(key)
	
	if available_levels.empty(): # Display boss level
		if not AppManager.levels_beaten[3]:
			option_3.visible = true
			option_3.connect("pressed", self, "_on_option_3")
			BgmManager.play_level_select()
		else:
			BgmManager.play_you_win()
			var label := Label.new()
			label.autowrap = true
			label.text = "Thanks for playing! You finished with a score of %.2f" % AppManager.player_session_score
			$GUI/Choices/VBoxContainer.add_child(label)
	else:
		BgmManager.play_level_select()
		for i in available_levels:
			match i:
				1:
					option_1.visible = true
					option_1.connect("pressed", self, "_on_option_1")
				2:
					option_2.visible = true
					option_2.connect("pressed", self, "_on_option_2")

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_chatter() -> void:
	chatter_timer.start(CHATTER_TIME)
	
	match chat_state:
		ChatStates.ONE:
			_create_new_chat_bubble()
			chat_state = ChatStates.TWO
		ChatStates.TWO:
			current_message.text = current_message.text + " ."
			chat_state = ChatStates.THREE
		ChatStates.THREE:
			current_message.text = current_message.text + " ."
			chat_state = ChatStates.SEND
		ChatStates.SEND:
			current_message.text = _generate_chat_text()
			chat_state = ChatStates.ONE

func _on_option_1() -> void:
	_change_screen("res://scenarios/scenario_1.tscn")

func _on_option_2() -> void:
	_change_screen("res://scenarios/scenario_2.tscn")

func _on_option_3() -> void:
	_change_screen("res://scenarios/final_scenario.tscn")

###############################################################################
# Private functions                                                           #
###############################################################################

func _create_new_chat_bubble() -> void:
	var message := Label.new()
	if is_left:
		message.align = Label.ALIGN_LEFT
		is_left = false
	else:
		message.align = Label.ALIGN_RIGHT
		is_left = true
	message.autowrap = true
	message.text = "."
	dialogue.call_deferred("add_child", message)
	current_message = message

func _generate_chat_text() -> String:
	var result: String = ""
	
	result = CHAT_MESSAGES[round(rand_range(0, CHAT_MESSAGES.size() - 1))]
	
	return result

func _change_screen(path: String) -> void:
	var new_screen = load("res://screens/combat_screen.tscn").instance()
	new_screen.scenario_path = path
	
	AppManager.main.change_screen(new_screen)

###############################################################################
# Public functions                                                            #
###############################################################################
