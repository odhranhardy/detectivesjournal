# scripts/Main.gd
extends Control

@onready var continue_button = $VBoxContainer/ContinueButton

func _ready():
	print("=== The Detective's Journal ===")
	print("Main menu loaded")
	
	# Check if save file exists to enable/disable continue button
	_update_continue_button()

func _update_continue_button():
	"""Enable continue button only if save file exists"""
	var save_file = FileAccess.open(SaveSystem.SAVE_FILE, FileAccess.READ)
	if save_file:
		save_file.close()
		continue_button.disabled = false
		continue_button.text = "Continue Investigation"
	else:
		continue_button.disabled = true
		continue_button.text = "No Saved Game"

func _on_new_game_pressed():
	print("Starting new case...")
	# TODO: Load case selection scene or start first case
	GameManager.start_case("missing_influencer")
	print("Started case: The Missing Influencer")

func _on_continue_pressed():
	print("Loading saved game...")
	if SaveSystem.load_game():
		print("Game loaded successfully")
		# TODO: Load investigation scene with current case
	else:
		print("Failed to load game")

func _on_dice_test_pressed():
	print("Opening dice test scene...")
	get_tree().change_scene_to_file("res://scenes/ui/DiceTest.tscn")

func _input(event):
	# Keep debug functionality for development
	if event.is_action_pressed("ui_accept"):  # Space or Enter
		print("Debug: Testing save system...")
		SaveSystem.save_game()
		_update_continue_button()
	
	if event.is_action_pressed("ui_cancel"):  # Escape
		print("Debug: Testing load system...")
		SaveSystem.load_game()
