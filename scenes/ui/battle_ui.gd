class_name BattleUI
extends CanvasLayer

@export var char_stats: CharacterStats : set = _set_char_stats

@onready var hand: Hand = $Hand # as Hand
@onready var mana_ui: ManaUI = $ManaUI # as ManaUI
@onready var credit_ui: CreditUI = %CreditUI
@onready var end_turn_button: Button = %EndTurnButton
@onready var draw_card_button: Button = %DrawCardButton
@onready var gain_credit_button: Button = %GainCreditButton


@onready var draw_pile_button: CardPileOpener = %DrawPileButton
@onready var discard_pile_button: CardPileOpener = %DiscardPileButton
#CANVAS -> CardPileViews
@onready var draw_pile_view: CardPileView = %DrawPileView
@onready var discard_pile_view: CardPileView = %DiscardPileView


func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	draw_card_button.pressed.connect(_on_draw_card_button_pressed)
	gain_credit_button.pressed.connect(_on_gain_credit_button_pressed)
	draw_pile_button.pressed.connect(draw_pile_view.show_current_view.bind("Draw Pile", true))
	discard_pile_button.pressed.connect(discard_pile_view.show_current_view.bind("Discard Pile", false))


#func initialize_card_piles() -> void:
func initialize_card_pile_ui() -> void:
	draw_pile_button.card_pile = char_stats.draw_pile
	draw_pile_view.card_pile = char_stats.draw_pile
	discard_pile_button.card_pile = char_stats.discard_pile
	discard_pile_view.card_pile = char_stats.discard_pile

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	mana_ui.char_stats = char_stats
	credit_ui.char_stats = char_stats
	hand.char_stats = char_stats
	#caution with this line
	char_stats.stats_changed.connect(_on_char_stats_changed)

func _on_player_hand_drawn() -> void:
	end_turn_button.disabled = false

func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	Events.player_turn_ended.emit()

func _on_draw_card_button_pressed() -> void:
	#PlayerHandler.add_card()
	#arriballamas al end_turn de una manera similar seguir el emit
	char_stats.mana -= 1
	Events.player_card_drawn.emit()
	
func _on_gain_credit_button_pressed() -> void:
	char_stats.add_credit(1)
	char_stats.mana -= 1
	Events.player_credits_gained.emit()

func _on_char_stats_changed( ) -> void:
	credit_button_to_false()
	draw_button_to_false()

func credit_button_to_false() -> void:
	if char_stats.mana <= 0:
		gain_credit_button.disabled = true
	else:
		gain_credit_button.disabled = false

func draw_button_to_false() -> void:
	if char_stats.mana <= 0:
		draw_card_button.disabled = true
	else:
		draw_card_button.disabled = false
