class_name Run
extends Node

const BATTLE_SCENE = preload("res://scenes/battle/battle.tscn")
#const MAP_SCENE = preload("res://scenes/map/map.tscn")
const SHOP_SCENE = preload("res://scenes/shop/shop.tscn")
const TREASURE_SCENE = preload("res://scenes/treasure/treasure.tscn")
const BATTLE_REWARDS_SCENE = preload("res://scenes/battle_rewards/battle_rewards.tscn")
const CAMPFIRE_SCENE = preload("res://scenes/campfire/campfire.tscn")
#hasta que no hagamos la de eventos usaremos la de la tienda
const EVENT_SCENE = preload("res://scenes/shop/shop.tscn")

const WIN_SCREEN_SCENE = preload("res://scenes/win_screen/win_screen.tscn")

@onready var map: Map = $Map

@export var run_startup: RunStartup

@onready var current_view: Node = $CurrentView

@onready var deck_button: CardPileOpener = %DeckButton
#@onready var deck_pile_view: CardPileView = $TopBar/DeckPileView
@onready var deck_pile_view: CardPileView = %DeckPileView
@onready var artifact_handler: ArtifactHandler = %ArtifactHandler
@onready var artifact_tooltip: ArtifactTooltip = %ArtifactTooltip
@onready var health_ui: HealthUI = %HealthUI
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
	
	map.generate_new_map()
	map.unlock_floor(0)
	
	#test_money
	#await get_tree().create_timer(2).timeout
	#stats.money += 55 

func _change_view(scene: PackedScene) -> Node:
	#cuando cambiamos si hay hijos primero los borramos
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	#battleoverscreen paused the game unchecked necessary
	get_tree().paused = false
	var new_view : Node = scene.instantiate()
	current_view.add_child(new_view)
	map.hide_map()
	
	return new_view

func _show_map() -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	map.show_map()
	map.unlock_next_rooms()

func _setup_event_connections() -> void:
	
	Events.battle_won.connect(_on_battle_won)
	Events.battle_reward_exited.connect(_show_map)
	Events.shop_exited.connect(_show_map)
	Events.campfire_exited.connect(_show_map)
	Events.treasure_room_exited.connect(_on_treasure_room_exited)
	
	Events.map_exited.connect(_on_map_exited)
	
	map_button.pressed.connect(_show_map)
	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARDS_SCENE))
	shop_button.pressed.connect(_change_view.bind(SHOP_SCENE))
	treasure_button.pressed.connect(_change_view.bind(TREASURE_SCENE))
	campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	
func _on_battle_room_entered(room: Room) -> void:
	var battle_scene: Battle = _change_view(BATTLE_SCENE) as Battle
	battle_scene.char_stats = character
	battle_scene.battle_stats = room.battle_stats
	battle_scene.artifacts = artifact_handler
	battle_scene.start_battle()
	
func _on_battle_won() -> void:
	if map.floors_climbed == MapGenerator.FLOORS:
		var win_screen := _change_view(WIN_SCREEN_SCENE) as WinScreen
		#win_screen.character = character
	else:
		_show_regular_battle_rewards()

func _show_regular_battle_rewards() -> void:
	var reward_scene := _change_view(BATTLE_REWARDS_SCENE) as BattleReward
	reward_scene.run_stats = stats
	reward_scene.character_stats = character
	
	
	reward_scene.add_money_reward(map.last_room.battle_stats.roll_gold_reward())
	reward_scene.add_card_reward()

func _on_campfire_entered() -> void:
	var campfire := _change_view(CAMPFIRE_SCENE) as Campfire
	campfire.char_stats = character
	campfire.run_stats = stats
	
func _on_shop_entered() -> void:
	var shop := _change_view(SHOP_SCENE) as Shop
	shop.char_stats = character
	shop.run_stats = stats
	shop.artifact_handler = artifact_handler
	Events.shop_entered.emit(shop)
	shop.populate_shop()

func _on_treasure_room_entered() -> void:
	var treasure_scene := _change_view(TREASURE_SCENE) as Treasure
	treasure_scene.artifact_handler = artifact_handler
	treasure_scene.char_stats = character
	treasure_scene.generate_artifact()

func _on_treasure_room_exited(artifact: Artifact) -> void:
	var reward_scene := _change_view(BATTLE_REWARDS_SCENE) as BattleReward
	reward_scene.run_stats = stats
	reward_scene.character_stats = character
	reward_scene.artifact_handler = artifact_handler
	
	reward_scene.add_artifact_reward(artifact)

func _setup_top_bar() -> void:
	character.stats_changed.connect(health_ui.update_stats.bind(character))
	health_ui.update_stats(character) 
	money_ui.run_stats = stats
	#artifacts setup
	artifact_handler.add_artifact(character.starting_artifact)
	Events.artifact_tooltip_requested.connect(artifact_tooltip.show_tooltip)
	
	deck_button.card_pile = character.deck
	deck_pile_view.card_pile = character.deck
	deck_button.pressed.connect(deck_pile_view.show_current_view.bind("Deck Pile", false))
	
func _on_map_exited(room : Room) -> void:
	print("TO DO WIP: enter a room")
	match room.type:
		Room.Type.MONSTER:
			_on_battle_room_entered(room)
		Room.Type.TREASURE:
			#_change_view(TREASURE_SCENE)
			_on_treasure_room_entered()
		Room.Type.CAMPFIRE:
			_on_campfire_entered()
		Room.Type.SHOP:
			_on_shop_entered()
		Room.Type.BOSS:
			_on_battle_room_entered(room)
		Room.Type.EVENT:
			_change_view(EVENT_SCENE)
