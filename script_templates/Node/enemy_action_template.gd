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

#override base_behaviourin the enemy dynamic intent
func update_intent_text() -> void:
	var player := target as Player
	if not player:
		return
	
	var modified_dmg := player.modifier_handler.get_modified_value(4, Modifier.Type.DMG_TAKEN)
	intent.current_text = intent.base_text % modified_dmg
