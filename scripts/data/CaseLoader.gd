extends Node
class_name CaseLoader

static func load_case(case_id: String) -> Dictionary:
	"""Load case data from JSON file"""
	var file_path = "res://data/cases/" + case_id + ".json"
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if not file:
		print("Error: Could not load case file: ", file_path)
		return {}
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		print("Error: Could not parse case JSON: ", file_path)
		return {}
	
	var case_data = json.data
	print("Loaded case: ", case_data.get("title", "Unknown"))
	return case_data

static func get_action_data(case_data: Dictionary, action_id: String) -> Dictionary:
	"""Get specific action data from case"""
	return case_data.get("actions", {}).get(action_id, {})

static func get_clue_data(case_data: Dictionary, clue_id: String) -> Dictionary:
	"""Get specific clue data from case"""
	return case_data.get("clues", {}).get(clue_id, {})

static func get_phase_data(case_data: Dictionary, phase_id: String) -> Dictionary:
	"""Get specific phase data from case"""
	return case_data.get("phases", {}).get(phase_id, {})

static func get_available_actions_for_phase(case_data: Dictionary, phase_id: String) -> Array:
	"""Get available actions for a specific phase"""
	var phase_data = get_phase_data(case_data, phase_id)
	return phase_data.get("available_actions", [])
