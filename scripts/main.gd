# scripts/Main.gd
extends Node2D

func _ready():
	print("=== Detective's Journal - Test Scene ===")
	print("Player Stats:")
	print("  Observation: +", GameManager.player_observation)
	print("  Rhetoric: +", GameManager.player_rhetoric)
	
	# Test starting a case
	GameManager.start_case("missing_influencer")
	
	# Test discovering a clue
	GameManager.discover_clue("cafe_discrepancy")
	
	# Test performing an action
	GameManager.perform_action("visit_cafe")
	
	print("Available actions: ", GameManager.available_actions)
	print("Completed actions: ", GameManager.completed_actions)
	print("Discovered clues: ", GameManager.discovered_clues)

func _input(event):
	if event.is_action_pressed("ui_accept"):  # Space or Enter
		print("Testing save system...")
		SaveSystem.save_game()
	
	if event.is_action_pressed("ui_cancel"):  # Escape
		print("Testing load system...")
		SaveSystem.load_game()
