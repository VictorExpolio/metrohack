class_name CharacterStats
extends Stats

@export_group("Visuals")
@export var character_name : String
@export_multiline var description : String
@export var portrait: Texture

@export_group("Gameplay Data")
@export var starting_deck: CardPile
@export var draftable_cards: CardPile
@export var cards_per_turn : int
@export var max_hand_size : int
@export var max_mana : int
@export var starting_artifact: Artifact

var cards_in_hand : int
var mana: int : set = set_mana
var credit: int : set = set_credit
var starting_credit := 0
var deck: CardPile
var discard_pile: CardPile
var draw_pile : CardPile

func set_mana(value : int) -> void:
	mana = value
	stats_changed.emit()
	
func reset_mana() -> void:
	mana = max_mana

func reset_credit() -> void:
	credit = starting_credit

func take_damage(damage : int) -> void:
	var initial_health : int = health
	super.take_damage(damage)
	if initial_health > health:
		Events.player_hurt.emit()

func add_mana(amount : int) -> void:
	mana += amount

func set_credit(value : int) -> void:
	credit = value
	stats_changed.emit()

func add_credit(amount : int) -> void:
	credit += amount

func can_play_card(card : Card) -> bool:
	#OJO AQUI bool
	return mana >= card.cost and credit >= card.credit_cost
	
func create_instance() -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.health = max_health
	instance.block = 0
	instance.reset_mana()
	instance.deck = instance.starting_deck.duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard_pile = CardPile.new()
	return instance
