extends Node2D

const CAMERA_SCROLL_SPEED: float = 15.0
const CAMERA_ZOOM_AMOUNT: Vector2 = Vector2(0.1, 0.1)

const ResultOverlay: PackedScene = preload("res://screens/result_overlay.tscn")
const LevelSelect: PackedScene = preload("res://screens/level_select.tscn")

onready var camera: Camera2D = $Camera2D
onready var viewport: Viewport = get_viewport()
onready var color_rect: ColorRect = $Background/ColorRect
onready var entities: YSort = $Entities

onready var objective_counter_ui: Label = $GUI/InfoBox/VBoxContainer/Current/Value
onready var death_ball_counter_container: VBoxContainer = $GUI/UnitCount/DeathBallCounter
onready var unit_count_ui: Label = $GUI/UnitCount/DeathBallCounter/Value
onready var countdown_container: VBoxContainer = $GUI/UnitCount/Countdown
onready var lose_counter_ui: Label = $GUI/UnitCount/Countdown/Value

onready var initial_camera_zoom: Vector2 = camera.zoom

var last_mouse_position := Vector2.ZERO

onready var death_ball: DeathBall = $DeathBall
var unit_count: int = 0

const LOSE_TIME: float = 5.0
var lose_counter: float = 0.0
var has_lost := false

var scenario: BaseScenario
var scenario_path: String = ""
var is_save_animals := false
var objective_counter: int = 0
var expected_count: int = 9999
var has_won := false

###############################################################################
# Builtin functions                                                           #
###############################################################################

func _ready() -> void:
	_setup()
	
	SignalBroadcaster.connect("combat_result_accept", self, "_on_combat_result_accept")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("secondary"):
		last_mouse_position = viewport.get_mouse_position()
	elif Input.is_action_pressed("secondary"):
		var current_mouse_position = viewport.get_mouse_position()
		
		# TODO add momentum
		camera.translate((last_mouse_position - current_mouse_position).normalized() * CAMERA_SCROLL_SPEED * delta * 60)
		
		last_mouse_position = current_mouse_position

	unit_count = death_ball.units.size()
	unit_count_ui.text = str(unit_count)
	
	if unit_count < 1:
		death_ball_counter_container.visible = false
		countdown_container.visible = true
		lose_counter += delta
		if lose_counter > LOSE_TIME:
			_display_results(false)
		lose_counter_ui.text = str(floor(clamp(LOSE_TIME - lose_counter, 0.0, LOSE_TIME)))
	else:
		death_ball_counter_container.visible = true
		countdown_container.visible = false
		lose_counter = 0.0
	
	if is_save_animals:
		objective_counter = unit_count

	objective_counter_ui.text = str(objective_counter)
	
	if objective_counter >= expected_count:
		_display_results(true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		camera.zoom -= CAMERA_ZOOM_AMOUNT
		if camera.zoom.x < 0.3:
			camera.zoom.x = 0.3
			camera.zoom.y = 0.3
	elif event.is_action_pressed("zoom_out"):
		camera.zoom += CAMERA_ZOOM_AMOUNT
	elif event.is_action_pressed("middle_click"):
		camera.zoom = initial_camera_zoom
		camera.global_position = death_ball.global_position

###############################################################################
# Connections                                                                 #
###############################################################################

func _on_count_objective() -> void:
	objective_counter += 1

func _on_combat_result_accept() -> void:
	var new_screen: Node
	if has_won:
		new_screen = LevelSelect.instance()
		# TODO pass params to level select
		
	else:
		new_screen = load("res://screens/combat_screen.tscn").instance()
		new_screen.scenario_path = scenario_path
#		new_screen.scenario = scenario.duplicate()
	AppManager.main.change_screen(new_screen)

###############################################################################
# Private functions                                                           #
###############################################################################

func _setup() -> void:
	# Just in case we load in without a scenario
	if not scenario_path:
		scenario_path = "res://scenarios/tutorial_scenario.tscn"
	
	scenario = load(scenario_path).instance()
	
	color_rect.color = scenario.background_color
	expected_count = scenario.objective_count

	var final_objective_value: String = "%s  %d  %s"
	var noun: String = "owo"
	var number: int = expected_count
	var verb: String = "uwu"
	match scenario.objective:
		BaseScenario.Objective.ENEMY:
			verb = "Kill"
			noun = "enemies"
			if number <= 1:
				noun = "enemy"
			SignalBroadcaster.connect("enemy_killed", self, "_on_count_objective")
		BaseScenario.Objective.BUILDING:
			verb = "Destroy"
			noun = "buildings"
			if number <= 1:
				noun = "building"
			SignalBroadcaster.connect("building_destroyed", self, "_on_count_objective")
		BaseScenario.Objective.SAVE:
			verb = "Save"
			noun = "animals"
			if number <= 1:
				noun = "animal"
			is_save_animals = true
		BaseScenario.Objective.BOSS:
			verb = "Kill"
			noun = "bosses"
			if number <= 1:
				noun = "boss"
			SignalBroadcaster.connect("boss_killed", self, "_on_count_objective")

	$GUI/InfoBox/VBoxContainer/Objective/Value.text = final_objective_value % [verb, number, noun]
	
	entities.call_deferred("add_child", scenario)

func _display_results(is_win: bool) -> void:
	if (not has_won and not has_lost):
		var result: CanvasLayer = ResultOverlay.instance()
		result.is_win = is_win
		call_deferred("add_child", result)
		
		match is_win:
			true:
				has_won = true
			false:
				has_lost = true

###############################################################################
# Public functions                                                            #
###############################################################################
