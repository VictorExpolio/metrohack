#meta-description: What happens when a card is played
#cambiar true strenght X true battery
extends Card

const TRUE_BATTERY_STATUS = preload("res://statuses/true_battery.tres")

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	print("Apply status CHARGED x 1")
	var status_effect := StatusEffect.new()
	var true_battery := TRUE_BATTERY_STATUS.duplicate()
	status_effect.status = true_battery
	status_effect.execute(targets)
