extends Control

@onready var case_title = $ScrollContainer/VBoxContainer/TitleContainer/CaseTitle
@onready var case_description = $ScrollContainer/VBoxContainer/TitleContainer/CaseDescription
@onready var actions_container = $ScrollContainer/VBoxContainer/ActionsPanel/ActionsVBox/ActionsContainer
@onready var clues_container = $ScrollContainer/VBoxContainer/CluesPanel/CluesVBox/CluesContainer

func _ready():
	print("Investigation scene loaded")
	_update_case_display()
	_update_actions()
	_update_clues()

func _update_case_display():
	"""Update the case title and description"""
	if GameManager.current_case_data.is_empty():
		case_title.text = "No Case Loaded"
		case_description.text = "Please start a case from the main menu."
		return
	
	case_title.text = GameManager.current_case_data.get("title", "Unknown Case")
	case_description.text = GameManager.current_case_data.get("description", "No description available.")

func _update_actions():
	"""Update the available actions list"""
	# Clear existing action buttons
	for child in actions_container.get_children():
		child.queue_free()
	
	# Add buttons for each available action
	for action_id in GameManager.available_actions:
		var action_data = CaseLoader.get_action_data(GameManager.current_case_data, action_id)
		var button = Button.new()
		button.text = action_data.get("title", action_id)
		button.custom_minimum_size = Vector2(0, 45)
		button.pressed.connect(_on_action_pressed.bind(action_id))
		actions_container.add_child(button)
		
		# Add spacing between action buttons
		if action_id != GameManager.available_actions[-1]:
			var spacer = Control.new()
			spacer.custom_minimum_size = Vector2(0, 8)
			actions_container.add_child(spacer)

func _update_clues():
	"""Update the discovered clues list"""
	# Clear existing clue labels
	for child in clues_container.get_children():
		child.queue_free()
	
	# Add labels for each discovered clue
	for clue_id in GameManager.discovered_clues:
		var clue_data = CaseLoader.get_clue_data(GameManager.current_case_data, clue_id)
		
		# Create clue panel
		var clue_panel = Panel.new()
		var clue_vbox = VBoxContainer.new()
		clue_panel.add_child(clue_vbox)
		
		# Clue title
		var title_label = Label.new()
		title_label.text = "🔍 " + clue_data.get("title", clue_id)
		title_label.theme_override_colors.font_color = Color(0.9, 0.85, 0.7, 1)
		title_label.theme_override_font_sizes.font_size = 18
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		clue_vbox.add_child(title_label)
		
		# Clue description
		var desc_label = Label.new()
		desc_label.text = clue_data.get("description", "No description available.")
		desc_label.theme_override_colors.font_color = Color(0.8, 0.75, 0.65, 1)
		desc_label.theme_override_font_sizes.font_size = 14
		desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		clue_vbox.add_child(desc_label)
		
		# Add margins
		clue_vbox.position = Vector2(15, 10)
		clue_vbox.size = clue_panel.size - Vector2(30, 20)
		clue_vbox.anchors_preset = Control.PRESET_FULL_RECT
		clue_vbox.offset_left = 15
		clue_vbox.offset_top = 10
		clue_vbox.offset_right = -15
		clue_vbox.offset_bottom = -10
		
		clues_container.add_child(clue_panel)
		
		# Add spacing between clues
		if clue_id != GameManager.discovered_clues[-1]:
			var spacer = Control.new()
			spacer.custom_minimum_size = Vector2(0, 10)
			clues_container.add_child(spacer)

func _on_action_pressed(action_id: String):
	"""Handle when an action button is pressed"""
	print("Action selected: ", action_id)
	
	var result = GameManager.perform_action(action_id)
	if not result.get("success", false):
		print("Action failed: ", result.get("error", "Unknown error"))
		return
	
	var action_data = result.get("action_data", {})
	
	if result.get("requires_dice_roll", false):
		# Action requires dice roll - transition to dice rolling
		_start_dice_roll(action_id, action_data)
	else:
		# Action doesn't require dice roll - resolve immediately
		var clue_result = GameManager.resolve_action_with_dice_result(action_id, true)
		_show_action_result(action_data, clue_result)

func _start_dice_roll(action_id: String, action_data: Dictionary):
	"""Start dice rolling for an action"""
	var skill = action_data.get("skill_required", "observation")
	var difficulty = action_data.get("difficulty", 11)
	var modifier = GameManager.get_skill_modifier(skill)
	
	print("Starting dice roll for %s: %s +%d vs %d" % [action_data.get("title", action_id), skill, modifier, difficulty])
	
	# TODO: Transition to dice rolling scene
	# For now, simulate dice roll
	var dice_result = (randi() % 6 + 1) + (randi() % 6 + 1) + modifier
	var success = dice_result >= difficulty
	
	var clue_result = GameManager.resolve_action_with_dice_result(action_id, success)
	_show_action_result(action_data, clue_result)

func _show_action_result(action_data: Dictionary, clue_result: Dictionary):
	"""Show the result of an action"""
	var clue_data = clue_result.get("clue_data", {})
	var success = clue_result.get("success", false)
	
	print("Action result: ", action_data.get("title", "Unknown"))
	print("Success: ", success)
	print("Clue: ", clue_data.get("title", "No clue"))
	
	# Refresh the UI
	_update_actions()
	_update_clues()

func _on_back_button_pressed():
	"""Return to main menu"""
	get_tree().change_scene_to_file("res://scenes/main.tscn")
