#meta-description: What happens when a card is played
extends Card

func apply_effects(targets: Array[Node]) -> void:
	print("Apply status CHARGED x 2")
