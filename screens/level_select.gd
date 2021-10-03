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

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready():
	$AnimationPlayer.play("Run")
	
	chatter_timer.connect("timeout", self, "_on_chatter")
	chatter_timer.start(CHATTER_TIME)

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

###############################################################################
# Public functions                                                            #
###############################################################################
