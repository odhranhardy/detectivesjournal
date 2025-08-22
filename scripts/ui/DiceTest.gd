extends Control

@onready var button = $VBoxContainer/Button

func _ready():
	print("DiceTest scene loaded - checking if label and button appear centred")
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	print("Button pressed - positioning test successful!")
