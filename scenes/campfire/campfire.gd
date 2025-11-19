class_name Campfire
extends Control

@export var run_stats: RunStats
@export var char_stats: CharacterStats
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var amount_money : int = 50

func _on_rest_button_pressed() -> void:
	#para que la curación del +30% heal nos devuelva en int debemos rendodear
	char_stats.heal(ceili(char_stats.max_health * 0.3))
	animation_player.play("fade_out")

func _on_connect_button_pressed() -> void:
	_on_money_phone_taken(amount_money)
	animation_player.play("fade_out")


func _on_money_phone_taken(amount_money: int) -> void:
	if not run_stats:
		return
	
	run_stats.money += amount_money
	print(str(run_stats.money))

#called in the ANIMATION_PLAYER
func _on_fade_out_finished() -> void:
	Events.campfire_exited.emit()
