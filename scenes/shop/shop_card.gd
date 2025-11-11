class_name ShopCard
extends VBoxContainer

const CARD_MENU_UI = preload("res://scenes/ui/card_menu_ui.tscn")

@export var card : Card : set = set_card
#@export var money_cost : int : set = set_money

@onready var card_container: CenterContainer = %CardContainer
@onready var price: HBoxContainer = %Price
@onready var price_label: Label = %PriceLabel
@onready var buy_button: Button = %BuyButton

@onready var money_cost : int = randi_range(20, 80)
#var money_cost : int

var current_card_ui : CardMenuUI

func _ready() -> void:
	pass
	test_run()

func test_run() -> void:
	update(preload("res://custom_resources/run_stats_example.tres"))

func update(run_stats) -> void:
	if not card_container or not price or not buy_button:
		return
	
	#money_cost = current_card_ui.card.get_money_cost()
	price_label.text = str(money_cost)
	
	
	if run_stats.money >= money_cost:
		price_label.remove_theme_color_override("font_color")
		buy_button.disabled = false
	else:#desactivamos cada botón que cueste más que nuestro dinero
		price_label.add_theme_color_override("font_color", Color.RED)
		buy_button.disabled = true
	

func set_card(new_card : Card) -> void:
	if not is_node_ready():
		await  ready
	card = new_card
	
	for card_menu_ui: CardMenuUI in card_container.get_children():
		card_menu_ui.queue_free()
	
	var new_card_menu_ui := CARD_MENU_UI.instantiate() as CardMenuUI
	card_container.add_child(new_card_menu_ui)
	new_card_menu_ui.card = card
	current_card_ui = new_card_menu_ui
	#segundo destrozo
	current_card_ui.card.money_cost = money_cost
	#aqui viene el destrozo mio
	#new_card_menu_ui.card.money_cost = price_label
	#var str_money_cost = str(new_card_menu_ui.card.money_cost) 
	#str_money_cost = price_label.text
	#print(str(price_label))
	 

func set_money(new_money_cost : int) -> void:
	money_cost = new_money_cost
	card.money_cost = money_cost
	price_label.text = str(money_cost)
	print(str(money_cost))

func _on_buy_button_pressed() -> void:
	Events.shop_card_bought.emit(card, money_cost)
	card_container.queue_free()
	price.queue_free()
	buy_button.queue_free()
