extends Node2D

@export var char_stats: CharacterStats
@export var battle_music : AudioStream

@onready var battle_ui: BattleUI = $BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var player: Player = $Player


func _ready() -> void:
	#esto luego lo haremos en la run
	#nos sivre para modificar las stats sin cambiar las stats default
	var new_stats: CharacterStats = char_stats.create_instance()
	battle_ui.char_stats = new_stats
	player.stats = new_stats
	
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	Events.player_died.connect(_on_player_died)
	
	start_battle(new_stats)
	battle_ui.initialize_card_piles()

func start_battle(stats : CharacterStats) -> void:
	get_tree().paused = false
	MusicPlayer.play( battle_music, true)
	enemy_handler.reset_enemy_actions()
	print("Battle has started")
	player_handler.start_battle(stats)

func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		print("Victory!--V")
		Events.battle_over_screen_requested.emit("Victory!", BattleOverPanel.Type.WIN)

func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()

func _on_player_died() -> void:
	print("Lose : GAME OVER--X")
	Events.battle_over_screen_requested.emit("GAME OVER!", BattleOverPanel.Type.LOSE)
