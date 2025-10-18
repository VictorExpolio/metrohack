class_name Run
extends Node

const BATTLE_SCENE = preload("res://scenes/battle/battle.tscn")
const MAP_SCENE = preload("res://scenes/map/map.tscn")
const SHOP_SCENE = preload("res://scenes/shop/shop.tscn")
const TREASURE_SCENE = preload("res://scenes/treasure/treasure.tscn")
const BATTLE_REWARDS_SCENE = preload("res://scenes/battle_rewards/battle_rewards.tscn")
const CAMPFIRE_SCENE = preload("res://scenes/campfire/campfire.tscn")

@export var run_startup: RunStartup

@onready var current_view: Node = $CurrentView

@onready var deck_button: CardPileOpener = $TopBar/BarItems/DeckButton
@onready var deck_pile_view: CardPileView = $TopBar/DeckPileView
@onready var money_ui: MoneyUI = %MoneyUI


@onready var map_button: Button = %MapButton
@onready var battle_button: Button = %BattleButton
@onready var shop_button: Button = %ShopButton
@onready var treasure_button: Button = %TreasureButton
@onready var rewards_button: Button = %RewardsButton
@onready var campfire_button: Button = %CampfireButton

var stats : RunStats
var character : CharacterStats

func _ready() -> void:
	if not run_startup:
		return
	
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			character = run_startup.picked_tool.create_instance()
			_start_run()
		RunStartup.Type.CONTINUED_RUN:
			print("TO DO WIP: load/save system")

func _start_run() -> void:
	stats = RunStats.new()
	
	_setup_event_connections()
	_setup_top_bar()
	print("TO DO WIP: generate map")
	
	#test_money
	#await get_tree().create_timer(2).timeout
	#stats.money += 55 

func _change_view(scene: PackedScene) -> void:
	#cuando cambiamos si hay hijos primero los borramos
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	#battleoverscreen paused the game unchecked necessary
	get_tree().paused = false
	var new_view : Node = scene.instantiate()
	current_view.add_child(new_view)

func _setup_event_connections() -> void:
	
	Events.battle_won.connect(_change_view.bind(BATTLE_REWARDS_SCENE))
	Events.battle_reward_exited.connect(_change_view.bind(MAP_SCENE))
	Events.shop_exited.connect(_change_view.bind(MAP_SCENE))
	Events.treasure_room_exited.connect(_change_view.bind(MAP_SCENE))
	Events.campfire_exited.connect(_change_view.bind(MAP_SCENE))
	
	Events.map_exited.connect(_on_map_exited)
	
	map_button.pressed.connect(_change_view.bind(MAP_SCENE))
	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARDS_SCENE))
	shop_button.pressed.connect(_change_view.bind(SHOP_SCENE))
	treasure_button.pressed.connect(_change_view.bind(TREASURE_SCENE))
	campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	
func _setup_top_bar() -> void:
	money_ui.run_stats = stats
	deck_button.card_pile = character.deck
	deck_pile_view.card_pile = character.deck
	deck_button.pressed.connect(deck_pile_view.show_current_view.bind("Deck Pile", false))
	
func _on_map_exited() -> void:
	print("TO DO WIP: enter a room")
