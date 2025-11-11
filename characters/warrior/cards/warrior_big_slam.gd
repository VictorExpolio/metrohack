#meta-description: What happens when a card is played
extends Card

const EXPOSED_STATUS = preload("res://statuses/exposed.tres")

var base_damage := 5
var exposed_duration := 2

func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	#damage_effect.amount = base_damage
	damage_effect.sound = sound
	damage_effect.execute(targets)
	
	print("Apply status Exposed x2 to enemy")
	var status_effect := StatusEffect.new()
	var exposed := EXPOSED_STATUS.duplicate()
	exposed.duration = exposed_duration
	status_effect.status = exposed
	status_effect.execute(targets)

func get_default_tooltip() -> String:
	return tooltip_text % base_damage
	
func get_update_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modifies_dmg := player_modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	
	if enemy_modifiers:
		modifies_dmg = enemy_modifiers.get_modified_value(modifies_dmg, Modifier.Type.DMG_TAKEN)
	
	return tooltip_text % modifies_dmg
