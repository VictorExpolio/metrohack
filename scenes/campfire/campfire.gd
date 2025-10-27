class_name Campfire
extends Control

@export var char_stats: CharacterStats
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_rest_button_pressed() -> void:
	#para que la curación del +30% heal nos devuelva en int debemos rendodear
	char_stats.heal(ceili(char_stats.max_health * 0.3))
	animation_player.play("fade_out")

#called in the ANIMATION_PLAYER
func _on_fade_out_finished() -> void:
	Events.campfire_exited.emit()
