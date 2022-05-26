# The EgoVenture Notepad hint system
extends CanvasLayer


# The map of the goals. Each entry contains a dictionary
# of Goal objects
var goals: Array


# Wether the hints are currently shown
var _hints_shown: bool = false


# Basic style configuration
func _ready():
	$Control.hide()
	$Control/Panel.add_stylebox_override(
		"panel",
		$Control/Panel.get_stylebox(
			"notepad_panel",
			"Panel"
		)
	)
	$Control/Goals.add_color_override(
		"font_color",
		$Control/Goals.get_color(
			"goals",
			"Label"
		)
	)
	$Control/Hints.add_color_override(
		"font_color",
		$Control/Goals.get_color(
			"hints",
			"Label"
		)
	)
	$Control/Goals.add_font_override(
		"font",
		$Control/Goals.get_font(
			"goals", 
			"Label"
		)
	)
	$Control/Hints.add_font_override(
		"font",
		$Control/Hints.get_font(
			"hints",
			"Label"
		)
	)


# Configure the notepad and load the hints
func configure(configuration: GameConfiguration):
	$Control.theme = configuration.design_theme
	$Control/BackgroundPicture.texture = configuration.notepad_background
	
	$Control/Goals.rect_position = configuration.notepad_goals_rect.position
	$Control/Goals.rect_size = configuration.notepad_goals_rect.size
	$Control/Hints.rect_position = configuration.notepad_hints_rect.position
	$Control/Hints.rect_size = configuration.notepad_hints_rect.size
		
	var file = File.new()
	
	file.open(configuration.notepad_hints_file, File.READ)
	
	var current_goal: Goal = null
	
	while ! file.eof_reached():
		var line = file.get_csv_line(";")
		
		if line[0] == "New Goal":
			if current_goal != null:
				goals.append(current_goal)
			current_goal = Goal.new()
			current_goal.title = line[1]
			current_goal.id = int(line[2])
			current_goal.hints = []
		elif line.size() >= 2 and line[1] != "":
			current_goal.hints.append(line[1])
	
	goals.append(current_goal)


# A step of a goal was finished, advance the hints and
# switch to the next goal until a goal with an unfinished step comes along
func finished_step(goal_id: int, step: int):
	var goal = _get_goal(goal_id)
	var fulfillment_record = _get_fulfillment_record(goal)
	if not (step - 1) in fulfillment_record.fulfilled:
		fulfillment_record.fulfilled.append(step - 1)
		fulfillment_record.fulfilled.sort()
	

	if goal_id == EgoVenture.state.current_goal:
		goal = _get_goal(EgoVenture.state.current_goal)
		var first_unfulfilled_hint = _find_first_unfulfilled_hint(goal)
		while first_unfulfilled_hint == goal.hints.size():
			EgoVenture.state.current_goal = EgoVenture.state.current_goal + 1
			if EgoVenture.state.current_goal <= goals.size():
				goal = _get_goal(EgoVenture.state.current_goal)
				first_unfulfilled_hint = _find_first_unfulfilled_hint(goal)
			else:
				EgoVenture.state.current_goal = -1
				break
	
	EgoVenture.save_continue()


# Show the notepad
func show():
	if EgoVenture.state.current_goal != -1:
		var goal: Goal = _get_goal(EgoVenture.state.current_goal)
		$Control/Goals.text = goal.title
		$Control/Hints.text = ""
		_hints_shown = false
	else:
		$Control/Goals.text = ""
		$Control/Hints.text = ""
		_hints_shown = true
	$Control.show()


# Get the goal by id
func _get_goal(id: int) -> Goal:
	for goal in goals:
		if goal.id == id:
			return goal
	return null


# Show the hints of a goal
func _show_hints():
	$Control/Hints.text = ""
	var goal: Goal = _get_goal(EgoVenture.state.current_goal)
	var first_unfulfilled = _find_first_unfulfilled_hint(goal)
	$Control/Hints.text = goal.hints[first_unfulfilled]


# Toggle showing hints
#
# ** Arguments **
# 
# - event: The input event
func _on_Goals_gui_input(event):
	if event is InputEventMouseButton and \
			not (event as InputEventMouseButton).pressed and \
			EgoVenture.state.current_goal != -1:
		if _hints_shown:
			$Control/Hints.text = ""
		else:
			_show_hints()
		_hints_shown = not _hints_shown


# Get out of notepad
func _on_Close_pressed():
	$Control.hide()


# Find the first unfulfilled hint of a goal
# 
# ** Arguments **
#
# - goal: The goal to look for
#
# *Returns* The first unfulfilled hint. If all hints are fulfilled
# returns the size of the hints
func _find_first_unfulfilled_hint(goal: Goal) -> int:
	var fulfilled = _get_fulfillment_record(goal)
	var first_unfulfilled_hint = 0
	while first_unfulfilled_hint in fulfilled.fulfilled and \
			first_unfulfilled_hint < goal.hints.size():
		first_unfulfilled_hint = first_unfulfilled_hint + 1
	return first_unfulfilled_hint


# Get the fulfillment record of the corresonding goal
#
# ** Arguments **
#
# - goal: The goal to get the fulfillment record for
#
# *Returns* The fulfillment record or NULL
func _get_fulfillment_record(goal: Goal) -> FulfillmentRecord:
	for fulfilled in EgoVenture.state.goals_fulfilled:
		if (fulfilled as FulfillmentRecord).goal_id == goal.id:
			return fulfilled
	var fulfillment_record = FulfillmentRecord.new()
	fulfillment_record.goal_id = goal.id
	fulfillment_record.fulfilled = []
	EgoVenture.state.goals_fulfilled.append(fulfillment_record)
	return fulfillment_record
