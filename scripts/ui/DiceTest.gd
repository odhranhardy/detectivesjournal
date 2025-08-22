extends Control

@onready var dice_roll = $DiceRollInstance
@onready var test_buttons = $CenterContainer/VBoxContainer

func _on_observation_button_pressed():
	"""Test an Observation roll (Medium difficulty)"""
	var observation_modifier = GameManager.get_skill_modifier("observation")
	dice_roll.setup_roll("observation", observation_modifier, 11)
	_show_dice_roll()

func _on_rhetoric_button_pressed():
	"""Test a Rhetoric roll (Easy difficulty)"""
	var rhetoric_modifier = GameManager.get_skill_modifier("rhetoric")
	dice_roll.setup_roll("rhetoric", rhetoric_modifier, 8)
	_show_dice_roll()

func _on_hard_button_pressed():
	"""Test a Hard roll (Hard difficulty)"""
	var observation_modifier = GameManager.get_skill_modifier("observation")
	dice_roll.setup_roll("observation", observation_modifier, 14)
	_show_dice_roll()

func _show_dice_roll():
	"""Show the dice rolling interface"""
	test_buttons.visible = false
	dice_roll.visible = true

func _on_dice_roll_complete(success: bool, total: int):
	"""Handle dice roll completion"""
	print("Test completed - Success: %s, Total: %d" % [success, total])
	
	# Return to test menu
	dice_roll.visible = false
	test_buttons.visible = true
