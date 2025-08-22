# scripts/autoload/GameManager.gd
extends Node

signal investigation_phase_changed(new_phase: String)
signal clue_discovered(clue_id: String)
signal action_completed(action_id: String, success: bool)

# Player stats
var player_observation: int = 2
var player_rhetoric: int = 1

# Current game state
var current_case_id: String = ""
var current_phase: String = ""
var discovered_clues: Array = []
var completed_actions: Array = []
var available_actions: Array = []
var current_case_data: Dictionary = {}

func _ready():
	print("GameManager loaded successfully!")

func start_case(case_id: String) -> bool:
	current_case_data = CaseLoader.load_case(case_id)
	
	if current_case_data.is_empty():
		print("Error: Could not load case ", case_id)
		return false
	
	current_case_id = case_id
	current_phase = current_case_data.get("initial_phase", "initial_investigation")
	discovered_clues.clear()
	completed_actions.clear()
	
	# Load available actions for initial phase
	available_actions = CaseLoader.get_available_actions_for_phase(current_case_data, current_phase)
	
	print("Started case: ", current_case_data.get("title", case_id))
	print("Phase: ", current_phase)
	print("Available actions: ", available_actions)
	return true

func perform_action(action_id: String) -> Dictionary:
	"""Perform an investigation action and return result"""
	if not available_actions.has(action_id):
		print("Action not available: ", action_id)
		return {"success": false, "error": "Action not available"}
	
	if completed_actions.has(action_id):
		print("Action already completed: ", action_id)
		return {"success": false, "error": "Action already completed"}
	
	var action_data = CaseLoader.get_action_data(current_case_data, action_id)
	if action_data.is_empty():
		print("Action data not found: ", action_id)
		return {"success": false, "error": "Action data not found"}
	
	completed_actions.append(action_id)
	available_actions.erase(action_id)
	
	print("Performed action: ", action_data.get("title", action_id))
	return {
		"success": true,
		"action_data": action_data,
		"requires_dice_roll": action_data.get("skill_required", "none") != "none"
	}

func discover_clue(clue_id: String):
	if not discovered_clues.has(clue_id):
		discovered_clues.append(clue_id)
		var clue_data = CaseLoader.get_clue_data(current_case_data, clue_id)
		clue_discovered.emit(clue_id)
		print("Discovered clue: ", clue_data.get("title", clue_id))

func resolve_action_with_dice_result(action_id: String, dice_success: bool) -> Dictionary:
	"""Resolve an action based on dice roll result"""
	var action_data = CaseLoader.get_action_data(current_case_data, action_id)
	
	var clue_id = ""
	if dice_success:
		clue_id = action_data.get("success_clue", "")
	else:
		clue_id = action_data.get("failure_clue", "")
	
	if clue_id != "":
		discover_clue(clue_id)
	
	var clue_data = CaseLoader.get_clue_data(current_case_data, clue_id)
	
	return {
		"clue_discovered": clue_id,
		"clue_data": clue_data,
		"success": dice_success
	}

func update_available_actions():
	# Load actions for current phase
	if not current_case_data.is_empty():
		available_actions = CaseLoader.get_available_actions_for_phase(current_case_data, current_phase)
		# Remove completed actions
		for action in completed_actions:
			available_actions.erase(action)

func get_skill_modifier(skill: String) -> int:
	match skill.to_lower():
		"observation":
			return player_observation
		"rhetoric":
			return player_rhetoric
		_:
			return 0 
