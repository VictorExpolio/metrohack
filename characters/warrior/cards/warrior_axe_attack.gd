extends Card

var base_damage := 4

func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	#damage_effect.amount = 4
	damage_effect.sound = sound
	damage_effect.execute(targets)
	
func get_default_tooltip() -> String:
	return tooltip_text % base_damage
	
func get_update_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modifies_dmg := player_modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	
	if enemy_modifiers:
		modifies_dmg = enemy_modifiers.get_modified_value(modifies_dmg, Modifier.Type.DMG_TAKEN)
	
	return tooltip_text % modifies_dmg
