#meta-description: What happens when a card is played
extends Card

var base_block := 10

func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var block_effect := BlockEffect.new()
	block_effect.amount = modifiers.get_modified_value(base_block, Modifier.Type.BLOCK_ADDED)
	block_effect.sound = sound
	block_effect.execute(targets)
	
func get_default_tooltip() -> String:
	return tooltip_text % base_block
	
func get_update_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	#luego modificar esto para añadir modifiers++Block
	
	return tooltip_text % base_block
	
