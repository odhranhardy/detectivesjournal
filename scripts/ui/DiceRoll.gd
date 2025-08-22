extends Control

signal dice_roll_complete(success: bool, total: int)

@onready var skill_label = $VBoxContainer/SkillLabel
@onready var difficulty_label = $VBoxContainer/DifficultyLabel
@onready var roll_button = $VBoxContainer/RollButton
@onready var dice_result_label = $VBoxContainer/ResultContainer/DiceResultLabel
@onready var total_label = $VBoxContainer/ResultContainer/TotalLabel
@onready var outcome_label = $VBoxContainer/ResultContainer/OutcomeLabel
@onready var continue_button = $VBoxContainer/ContinueButton

var skill_name: String = ""
var skill_modifier: int = 0
var target_difficulty: int = 11
var roll_result: int = 0
var total_result: int = 0
var success: bool = false

func _ready():
	# Hide result elements initially
	dice_result_label.visible = false
	total_label.visible = false
	outcome_label.visible = false

func setup_roll(skill: String, modifier: int, difficulty: int):
	"""Setup the dice roll with skill, modifier, and target difficulty"""
	skill_name = skill
	skill_modifier = modifier
	target_difficulty = difficulty
	
	# Update UI labels
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
	roll_button.visible = true
	continue_button.visible = false
	dice_result_label.visible = false
	total_label.visible = false
	outcome_label.visible = false

func _on_roll_button_pressed():
	"""Handle the dice roll when button is pressed"""
	# Roll 2d6
	var die1 = randi() % 6 + 1
	var die2 = randi() % 6 + 1
	roll_result = die1 + die2
	total_result = roll_result + skill_modifier
	success = total_result >= target_difficulty
	
	# Update UI with results
	dice_result_label.text = "Rolled: %d + %d = %d" % [die1, die2, roll_result]
	total_label.text = "Total: %d + %d = %d" % [roll_result, skill_modifier, total_result]
	
	if success:
		outcome_label.text = "SUCCESS!"
		outcome_label.modulate = Color.GREEN
	else:
		outcome_label.text = "FAILURE"
		outcome_label.modulate = Color.RED
	
	# Show results and continue button
	dice_result_label.visible = true
	total_label.visible = true
	outcome_label.visible = true
	roll_button.visible = false
	continue_button.visible = true
	
	print("Dice Roll - %s: %d+%d=%d vs %d - %s" % [
		skill_name, roll_result, skill_modifier, total_result, 
		target_difficulty, "SUCCESS" if success else "FAILURE"
	])

func _on_continue_button_pressed():
	"""Handle continue button press and emit completion signal"""
	dice_roll_complete.emit(success, total_result)
