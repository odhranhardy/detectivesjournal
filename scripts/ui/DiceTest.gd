extends Control

@onready var test_buttons = $MenuPanel
@onready var dice_roll_ui = $DiceRollPanel
@onready var skill_label = $DiceRollPanel/DiceRollContainer/SkillLabel
@onready var difficulty_label = $DiceRollPanel/DiceRollContainer/DifficultyLabel
@onready var roll_button = $DiceRollPanel/DiceRollContainer/RollButton
@onready var dice_result_label = $DiceRollPanel/DiceRollContainer/DiceResultLabel
@onready var total_label = $DiceRollPanel/DiceRollContainer/TotalLabel
@onready var outcome_label = $DiceRollPanel/DiceRollContainer/OutcomeLabel
@onready var continue_button = $DiceRollPanel/DiceRollContainer/ContinueButton

var skill_name: String = ""
var skill_modifier: int = 0
var target_difficulty: int = 11

func _ready():
	print("DiceTest scene loaded - dice rolling test ready")

func _on_observation_button_pressed():
	print("Testing Observation roll")
	_setup_roll("observation", 2, 11)

func _on_rhetoric_button_pressed():
	print("Testing Rhetoric roll")
	_setup_roll("rhetoric", 1, 8)

func _setup_roll(skill: String, modifier: int, difficulty: int):
	skill_name = skill
	skill_modifier = modifier
	target_difficulty = difficulty
	
	skill_label.text = "Rolling %s (+%d)" % [skill.capitalize(), modifier]
	
	var difficulty_text = ""
	if difficulty <= 10:
		difficulty_text = "Easy"
	elif difficulty <= 13:
		difficulty_text = "Medium"
	else:
		difficulty_text = "Hard"
	
	difficulty_label.text = "Target: %d (%s)" % [difficulty, difficulty_text]
	
	# Reset UI state
	dice_result_label.text = ""
	total_label.text = ""
	outcome_label.text = ""
	roll_button.visible = true
	continue_button.visible = false
	
	# Show dice rolling UI
	test_buttons.visible = false
	dice_roll_ui.visible = true

func _on_roll_button_pressed():
	print("Rolling dice for %s" % skill_name)
	
	# Roll 2d6
	var die1 = randi() % 6 + 1
	var die2 = randi() % 6 + 1
	var roll_result = die1 + die2
	var total_result = roll_result + skill_modifier
	var success = total_result >= target_difficulty
	
	# Update UI with results
	dice_result_label.text = "Rolled: %d + %d = %d" % [die1, die2, roll_result]
	total_label.text = "Total: %d + %d = %d" % [roll_result, skill_modifier, total_result]
	
	if success:
		outcome_label.text = "SUCCESS!"
		outcome_label.modulate = Color.GREEN
	else:
		outcome_label.text = "FAILURE"
		outcome_label.modulate = Color.RED
	
	# Show continue button
	roll_button.visible = false
	continue_button.visible = true
	
	print("Result: %d+%d=%d vs %d - %s" % [
		roll_result, skill_modifier, total_result, 
		target_difficulty, "SUCCESS" if success else "FAILURE"
	])

func _on_continue_button_pressed():
	print("Returning to test menu")
	dice_roll_ui.visible = false
	test_buttons.visible = true
