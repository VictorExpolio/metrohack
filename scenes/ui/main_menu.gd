extends Control

const TOOL_SELECTOR_SCENE := preload("res://scenes/ui/tool_selector.tscn")

@onready var continue_button : Button = %Continue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false

func _on_continue_pressed() -> void:
	print("Continue Run selected")

func _on_new_run_pressed() -> void:
	get_tree().change_scene_to_packed(TOOL_SELECTOR_SCENE)

func _on_exit_pressed() -> void:
	get_tree().quit()
