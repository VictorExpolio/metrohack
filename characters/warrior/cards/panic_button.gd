#meta-description: What happens when a card is played
extends Card

const EXPOSED_STATUS = preload("res://statuses/exposed.tres")

var base_block := 22
var exposed_duration := 3

func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var block_effect := BlockEffect.new()
	block_effect.amount = modifiers.get_modified_value(base_block, Modifier.Type.BLOCK_ADDED)
	block_effect.sound = sound
	block_effect.execute(targets)
	
	var status_effect := StatusEffect.new()
	var exposed := EXPOSED_STATUS.duplicate()
	status_effect.status = exposed
	exposed.duration = exposed_duration
	status_effect.execute(targets)
	
func get_default_tooltip() -> String:
	return tooltip_text % base_block
	
func get_update_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	#luego modificar esto para añadir modifiers++Block
	
	return tooltip_text % base_block
