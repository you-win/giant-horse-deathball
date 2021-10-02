extends CanvasLayer

const WIN_TEXT: String = "You win!"
const LOSE_TEXT: String = "You lose!"

const WIN_INSTRUCTION: String = "Press spacebar to go to next screen."
const LOSE_INSTRUCTION: String = "Press spacebar to retry."

onready var result: Label = $VBoxContainer/Result
onready var instruction: Label = $VBoxContainer/Instruction

var is_win := true

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready():
	if is_win:
		result.text = WIN_TEXT
		instruction.text = WIN_INSTRUCTION
	else:
		result.text = LOSE_TEXT
		instruction.text = LOSE_INSTRUCTION

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("combat_result_accept"):
		SignalBroadcaster.emit_signal("combat_result_accept")

###############################################################################
# Connections                                                                 #
###############################################################################

###############################################################################
# Private functions                                                           #
###############################################################################

###############################################################################
# Public functions                                                            #
###############################################################################
