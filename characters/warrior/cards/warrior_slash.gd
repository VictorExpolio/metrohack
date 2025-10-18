#meta-description: What happens when a card is played
extends Card

func apply_effects(targets: Array[Node]) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = 6
	damage_effect.sound = sound
	damage_effect.execute(targets)
	
