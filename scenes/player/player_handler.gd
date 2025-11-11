class_name PlayerHandler
extends Node

const HAND_DRAW_INTERVAL : float = 0.25
const HAND_DISCARD_INTERVAL : float = 0.15

@export var artifacts: ArtifactHandler
@export var player: Player
@export var hand: Hand

var character : CharacterStats

func _ready() -> void:
	Events.card_played.connect(_on_card_played)

func start_battle(char_stats: CharacterStats) -> void:
	character = char_stats
	character.draw_pile = character.deck.duplicate(true)
	character.draw_pile.shuffle()
	character.discard_pile = CardPile.new()
	artifacts.artifacts_activated.connect(_on_artifacts_activated)
	player.status_handler.statuses_applied.connect(_on_statuses_applied)
	start_turn()
	
	
func start_turn() -> void:
	character.block = 0
	character.reset_mana()
	artifacts.activate_artifacts_by_type(Artifact.Type.START_OF_TURN)
	#player.status_handler.apply_statuses_by_type(Status.Type.START_OF_TURN)
	#draw_cards(character.cards_per_turn)
	
func end_turn() -> void:
	hand.disabled_hand()
	artifacts.activate_artifacts_by_type(Artifact.Type.END_OF_TURN)
	#player.status_handler.apply_statuses_by_type(Status.Type.END_OF_TURN)
	#discard_cards()
	
func draw_card() -> void:
	reshuffle_deck_from_discard()
	hand.add_card(character.draw_pile.draw_card())
	reshuffle_deck_from_discard()
	
func draw_cards(amount : int) -> void:
	var tween : Tween = create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
	
	tween.finished.connect(
		func(): Events.player_hand_drawn.emit()
	)

func discard_cards() -> void:
	if hand.get_child_count() == 0:
		Events.player_hand_discarded.emit()
		return
	
	var tween := create_tween()
	for card_ui in hand.get_children():
		tween.tween_callback(character.discard_pile.add_card.bind(card_ui.card))
		tween.tween_callback(hand.discard_card.bind(card_ui))
		tween.tween_interval(HAND_DISCARD_INTERVAL)
	
	tween.finished.connect(
		func():
			Events.player_hand_discarded.emit() 
	)
	
func reshuffle_deck_from_discard() -> void:
	if not character.draw_pile.empty():
		return
	
	while not character.discard_pile.empty():
		character.draw_pile.add_card(character.discard_pile.draw_card())
	
	character.draw_pile.shuffle()
	
func _on_card_played(card: Card) -> void:
	if card.trashes or card.type == Card.Type.POWER: #or TODO Type.PROGRAM
		return
	
	character.discard_pile.add_card(card)

func _on_artifacts_activated(type: Artifact.Type) -> void:
	match type:
		Artifact.Type.START_OF_TURN:
			player.status_handler.apply_statuses_by_type(Status.Type.START_OF_TURN)
		Artifact.Type.END_OF_TURN:
			player.status_handler.apply_statuses_by_type(Status.Type.END_OF_TURN)

func _on_statuses_applied(type: Status.Type) -> void:
	match type:
		Status.Type.START_OF_TURN:
			draw_cards(character.cards_per_turn)
		Status.Type.END_OF_TURN:
			discard_cards()
	
