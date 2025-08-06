# scripts/autoload/SaveSystem.gd
extends Node

const SAVE_FILE = "user://detective_save.dat"

func save_game():
	var save_dict = {
		"player_observation": GameManager.player_observation,
		"player_rhetoric": GameManager.player_rhetoric,
		"current_case_id": GameManager.current_case_id,
		"current_phase": GameManager.current_phase,
		"discovered_clues": GameManager.discovered_clues,
		"completed_actions": GameManager.completed_actions,
		"version": "1.0"
	}
	
	var save_file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if save_file:
		save_file.store_string(JSON.stringify(save_dict))
		save_file.close()
		print("Game saved successfully!")
		return true
	else:
		print("Failed to save game!")
		return false

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_FILE):
		print("No save file found")
		return false
	
	var save_file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if not save_file:
		print("Failed to open save file")
		return false
	
	var json_string = save_file.get_as_text()
	save_file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		print("Failed to parse save file")
		return false
	
	var save_data = json.data
	
	# Restore game state
	GameManager.player_observation = save_data.get("player_observation", 2)
	GameManager.player_rhetoric = save_data.get("player_rhetoric", 1)
	GameManager.current_case_id = save_data.get("current_case_id", "")
	GameManager.current_phase = save_data.get("current_phase", "")
	GameManager.discovered_clues = save_data.get("discovered_clues", [])
	GameManager.completed_actions = save_data.get("completed_actions", [])
	
	print("Game loaded successfully!")
	return true

func _ready():
	print("SaveSystem loaded successfully!")
