class_name Battle
extends Node2D

@export var battle_stats: BattleStats
@export var char_stats: CharacterStats
@export var battle_music : AudioStream
@export var artifacts: ArtifactHandler

@onready var battle_ui: BattleUI = $BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var player: Player = $Player


func _ready() -> void:
	#nos sivre para modificar las stats sin cambiar las stats default
	#var new_stats: CharacterStats = char_stats.create_instance()
	#battle_ui.char_stats = new_stats
	#player.stats = new_stats
	
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_card_drawn.connect(player_handler.draw_card)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	Events.player_died.connect(_on_player_died)
	
	#start_battle()
	#battle_ui.initialize_card_pile_ui()

func start_battle() -> void:
	get_tree().paused = false
	MusicPlayer.play( battle_music, true)
	print("Battle has started")
	
	battle_ui.char_stats = char_stats
	player.stats = char_stats
	player_handler.artifacts = artifacts
	enemy_handler.setup_enemies(battle_stats)
	enemy_handler.reset_enemy_actions()
	
	artifacts.artifacts_activated.connect(_on_artifacts_activated)
	artifacts.activate_artifacts_by_type(Artifact.Type.START_OF_COMBAT)
	#player_handler.start_battle(char_stats)
	#battle_ui.initialize_card_pile_ui()

func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0 and is_instance_valid(artifacts):
		artifacts.activate_artifacts_by_type(Artifact.Type.END_OF_COMBAT)
		#Events.battle_over_screen_requested.emit("Victory!", BattleOverPanel.Type.WIN)

func _on_artifacts_activated(type: Artifact.Type) -> void:
	match type:
		Artifact.Type.START_OF_COMBAT:
			player_handler.start_battle(char_stats)
			battle_ui.initialize_card_pile_ui()
		Artifact.Type.END_OF_COMBAT:
			Events.battle_over_screen_requested.emit("Victory!", BattleOverPanel.Type.WIN)

func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()

func _on_player_died() -> void:
	print("Lose : GAME OVER--X")
	Events.battle_over_screen_requested.emit("GAME OVER!", BattleOverPanel.Type.LOSE)
