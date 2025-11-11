class_name Shop
extends Control

const SHOP_CARD = preload("res://scenes/shop/shop_card.tscn")
const SHOP_RELIC = preload("res://scenes/shop/shop_artifact.tscn")

@export var shop_artifacts : Array[Artifact]
@export var char_stats : CharacterStats
@export var run_stats : RunStats
@export var artifact_handler : ArtifactHandler

@onready var cards: HBoxContainer = %Cards
@onready var artifacts: HBoxContainer = %Artifacts
@onready var card_tooltip_popup: CardTooltipPopup = %CardTooltipPopup

@onready var modifier_handler: ModifierHandler = $ModifierHandler


func  _ready() -> void:
	for shop_card: ShopCard in cards.get_children():
		shop_card.queue_free()
	
	for shop_artifact: ShopArtifact in artifacts.get_children():
		shop_artifact.queue_free()
	
	Events.shop_card_bought.connect(_on_shop_card_bought)
	Events.shop_artifact_bought.connect(_on_shop_artifact_bought)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and card_tooltip_popup.visible:
		card_tooltip_popup.hide_tooltip()

func populate_shop() -> void:
	_generate_shop_cards()
	_generate_shop_artifacts()

func _generate_shop_cards() -> void:
	var shop_card_array : Array[Card] = []
	var available_cards := char_stats.draftable_cards.cards.duplicate(true)
	
	available_cards.shuffle()
	shop_card_array = available_cards.slice(0,3)
	
	for card: Card in shop_card_array:
		var new_shop_card := SHOP_CARD.instantiate() as ShopCard
		cards.add_child(new_shop_card)
		new_shop_card.card = card
		new_shop_card.current_card_ui.tooltip_requested.connect(card_tooltip_popup.show_tooltip)
		new_shop_card.money_cost = _get_updated_shop_cost(new_shop_card.money_cost)
		new_shop_card.update(run_stats)

func _update_item_cost() -> void:
	for shop_card: ShopCard in cards.get_children():
		shop_card.money_cost = _get_updated_shop_cost(shop_card.money_cost)
		shop_card.update(run_stats)
	
	for shop_artifact: ShopArtifact in artifacts.get_children():
		shop_artifact.money_cost = _get_updated_shop_cost(shop_artifact.money_cost)
		shop_artifact.update(run_stats)

func _generate_shop_artifacts() -> void:
	var shop_artifact_array : Array[Artifact] = []
	var available_artifacts := shop_artifacts.filter(
		func(artifact: Artifact):
			var can_appear:= artifact.can_apper_as_reward(char_stats)
			var already_had_it := artifact_handler.has_artifact(artifact.id)
			return can_appear and not already_had_it
	)
	available_artifacts.shuffle()
	shop_artifact_array = available_artifacts.slice(0, 3)
	
	for artifact : Artifact in shop_artifact_array:
		var new_shop_artifact := SHOP_RELIC.instantiate() as ShopArtifact
		artifacts.add_child(new_shop_artifact)
		new_shop_artifact.artifact = artifact
		new_shop_artifact.money_cost = _get_updated_shop_cost(new_shop_artifact.money_cost)
		new_shop_artifact.update(run_stats)

func _on_shop_card_bought(card: Card, money_cost : int) -> void:
	char_stats.deck.add_card(card)
	run_stats.money -= money_cost
	_update_items()

func _on_shop_artifact_bought(artifact: Artifact, money_cost : int) -> void:
	artifact_handler.add_artifact(artifact)
	run_stats.money -= money_cost
	
	if artifact is CodeDiscount:
		var code_discount_artifact := artifact as CodeDiscount
		code_discount_artifact.add_shop_modifier(self)
		_update_item_cost()
	else:
		_update_items()
	

func _update_items() -> void:
	for shop_card : ShopCard in cards.get_children():
		shop_card.update(run_stats)
	
	for shop_artifact : ShopArtifact in artifacts.get_children():
		shop_artifact.update(run_stats)

func _get_updated_shop_cost(original_cost: int) -> int:
	return modifier_handler.get_modified_value(original_cost, Modifier.Type.SHOP_COST)

func _on_back_button_pressed() -> void:
	Events.shop_exited.emit()
