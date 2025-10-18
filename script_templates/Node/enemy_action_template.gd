# meta-name: Enemy Action Logic
#meta-description: Action can be performed

extends EnemyAction

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var tween : Tween = create_tween().set_trans(Tween.TRANS_QUINT)
	var start : Vector2 = enemy.global_position
	var end : Vector2 = target.global_position + Vector2.LEFT * 48
	
	SFXPlayer.play(sound)
	print("An action is performed")
	
	Events.enemy_action_completed.emit(enemy)
	
