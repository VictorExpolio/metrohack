class_name Campfire
extends Control

@export var amount_money := 50
@export var run_stats: RunStats
@export var char_stats: CharacterStats
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_rest_button_pressed() -> void:
	char_stats.heal(ceili(char_stats.max_health * 0.3))
	animation_player.play("fade_out")

func _on_connect_button_pressed() -> void:
	if not run_stats:
		return
	
	run_stats.money += amount_money
	animation_player.play("fade_out")

#called in the ANIMATION_PLAYER
func _on_fade_out_finished() -> void:
	Events.campfire_exited.emit()
