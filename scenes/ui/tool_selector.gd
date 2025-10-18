extends Control

const RUN_SCENE = preload("res://scenes/run/run.tscn")
const DOLPHIN_STATS : CharacterStats = preload("res://characters/warrior/warrior.tres")
const ANT_STATS : CharacterStats = preload("res://characters/ant/ant.tres")
const VIPER_STATS : CharacterStats = preload("res://characters/viper/viper.tres")

@export var run_startup : RunStartup

@onready var tool_title: Label = $ToolTitle
@onready var tool_description: Label = $ToolDescription
@onready var tool_portrait: TextureRect = $Portrait

var current_tool : CharacterStats : set = set_current_character

func _ready() -> void:
	set_current_character(DOLPHIN_STATS)

func set_current_character(new_tool : CharacterStats) -> void:
	current_tool = new_tool
	tool_title.text = current_tool.character_name
	tool_description.text = current_tool.description
	tool_portrait.texture = current_tool.portrait

func _on_start_button_pressed() -> void:
	print("Start new Run with %s" % current_tool.character_name)
	run_startup.type = RunStartup.Type.NEW_RUN
	run_startup.picked_tool = current_tool
	get_tree().change_scene_to_packed(RUN_SCENE)

func _on_dolphin_button_pressed() -> void:
	current_tool = DOLPHIN_STATS

func _on_ant_button_pressed() -> void:
	current_tool = ANT_STATS 

func _on_viper_button_pressed() -> void:
	current_tool = VIPER_STATS 
