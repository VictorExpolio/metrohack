class_name ArtifactsControl
extends Control

const ARTIFACTS_PER_PAGE := 7
const TWEEN_SCROLL_DURATION := 0.2

@export var left_button: TextureButton
@export var right_button: TextureButton

@onready var artifacts: HBoxContainer = %Artifacts
@onready var page_width = self.custom_minimum_size.x

var num_of_artifacts := 0
var current_page := 1
var max_page := 0
var tween: Tween

func _ready() -> void:
	left_button.pressed.connect(_on_left_button_pressed)
	right_button.pressed.connect(_on_right_button_pressed)
	
	for artifact_ui: ArtifactUI in artifacts.get_children():
		artifact_ui.free() #TODO _ FIX LATER
	
	artifacts.child_order_changed.connect(_on_relics_child_order_changed)
	_on_relics_child_order_changed()

func update() -> void: #we call this on button pressed
	#safety check, para evitar que siga intentando acceder a estos nodos tras liberar la memoria del juego
	if not is_instance_valid(left_button) or not is_instance_valid(right_button):
		return
	num_of_artifacts = artifacts.get_child_count()
	max_page = ceili(num_of_artifacts/ float(ARTIFACTS_PER_PAGE))
	
	left_button.disabled = current_page <= 1
	#ffffff46
	left_button.modulate = Color(1, 1, 1, 0.5)
	right_button.disabled = current_page >= max_page
	
	button_pages_condition()

func button_pages_condition():
	if left_button.disabled:
		left_button.modulate = Color(1, 1, 1, 0.5)
	else:
		left_button.modulate = Color(1, 1, 1, 1)
		
	if right_button.disabled:
		right_button.modulate = Color(1, 1, 1, 0.5)
	else:
		right_button.modulate = Color(1, 1, 1, 1)
	
func _tween_to(x_position: float) -> void:
	if tween:
		tween.kill()
		
	tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(artifacts, "position:x", x_position, TWEEN_SCROLL_DURATION)

func _on_left_button_pressed() -> void:
	if current_page > 1:
		current_page -= 1
		update()
		_tween_to(artifacts.position.x + page_width)

func _on_right_button_pressed() -> void:
	if current_page < max_page:
		current_page += 1
		update()
		_tween_to(artifacts.position.x - page_width)

func _on_relics_child_order_changed() -> void:
	update()
	
	
