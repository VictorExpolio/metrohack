class_name CardVisuals
extends Control

@export var card : Card : set = set_card

@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon
@onready var rarity: TextureRect = $Rarity
@onready var credit_cost: Label = %CreditCost


func set_card(value : Card) -> void:
	if not is_node_ready():
		await ready

	card = value
	cost.text = str(card.cost)
	credit_cost.text = str(card.credit_cost)
	icon.texture = card.icon
	rarity.modulate = Card.RARITY_COLORS[card.rarity]
