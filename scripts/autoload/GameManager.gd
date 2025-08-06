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

func _ready():
	print("GameManager loaded successfully!")

func start_case(case_id: String):
	current_case_id = case_id
	discovered_clues.clear()
	completed_actions.clear()
	current_phase = "afternoon_investigation"
	update_available_actions()
	print("Started case: ", case_id)

func perform_action(action_id: String) -> bool:
	if action_id in available_actions:
		completed_actions.append(action_id)
		available_actions.erase(action_id)
		action_completed.emit(action_id, true)
		print("Completed action: ", action_id)
		return true
	return false

func discover_clue(clue_id: String):
	if clue_id not in discovered_clues:
		discovered_clues.append(clue_id)
		clue_discovered.emit(clue_id)
		print("Discovered clue: ", clue_id)

func update_available_actions():
	# For now, just add some test actions
	available_actions = ["visit_cafe", "analyze_social_media", "interview_alex"]
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
