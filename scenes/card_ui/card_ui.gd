class_name CardUI
extends Control

@warning_ignore("unused_signal")
signal reparent_requested(which_card_ui: CardUI)

const BASE_STYLEBOX := preload("res://scenes/card_ui/card_base_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scenes/card_ui/card_hover_stylebox.tres")
const DRAGGING_STYLEBOX := preload("res://scenes/card_ui/card_dragging_stylebox.tres")
#acceso a la clase de Resources
@export var card: Card : set = _set_card
@export var char_stats: CharacterStats : set = _set_character_stats
@export var player_modifiers: ModifierHandler
#FALTA REF TODO
@onready var card_visuals: CardVisuals = $CardVisuals
#@onready var panel: Panel = $Panel
#@onready var cost: Label = $Cost
#@onready var icon: TextureRect = $Icon

@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
#array que recorre los objetivos en juego
@onready var targets: Array[Node] = []

var original_index := 0
var parent: Control
var tween : Tween
#flaga playable vinculado a mana - disabled al controlador?
var playable := true : set = _set_playable
var disabled := false 


#Temp index
#@onready var index: Label = $Index

func _ready() -> void:
	Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_ended.connect(_on_card_drag_or_aiming_ended)
	Events.card_aim_ended.connect(_on_card_drag_or_aiming_ended)
	card_state_machine.init(self)
	#Temp index
	#index.text = str(get_index())
	
func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"global_position", new_position, duration)
	
func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)
	
func play() -> void:
	if not card:
		return
	
	card.play(targets, char_stats, player_modifiers)
	queue_free()
	
func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)
	
func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()
	
func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()
	
func get_active_enemy_modifiers() -> ModifierHandler:
	if targets.is_empty() or targets.size() > 1 or not targets[0] is Enemy:
		return null
	
	return targets[0].modifier_handler

func request_tooltip() -> void:
	var enemy_modifiers := get_active_enemy_modifiers()
	var updated_tooltip := card.get_update_tooltip(player_modifiers, enemy_modifiers)
	Events.card_tooltip_requested.emit(card.icon, updated_tooltip)

func _set_card(value : Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	card_visuals.card = card

func _set_playable (value: bool) -> void:
	playable = value
	if not playable:
		card_visuals.cost.add_theme_color_override("font_color", Color.RED)
		card_visuals.icon.modulate = Color(1, 1, 1, 0.5)
	else:
		card_visuals.cost.remove_theme_color_override("font_color")
		card_visuals.icon.modulate = Color(1, 1, 1, 1)

func _set_character_stats(value: CharacterStats) -> void:
	char_stats = value
	char_stats.stats_changed.connect(_on_char_stats_changed)


func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)

func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)

func _on_card_drag_or_aiming_started(used_card: CardUI) -> void:
	if used_card == self:
		return
	
	disabled = true
	
func _on_card_drag_or_aiming_ended(_card: CardUI) -> void:
	disabled = false
	playable = char_stats.can_play_card(card)
	
func _on_char_stats_changed( ) -> void:
	playable = char_stats.can_play_card(card)
