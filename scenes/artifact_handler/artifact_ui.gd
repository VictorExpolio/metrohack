class_name ArtifactUI
extends Control

@export var artifact: Artifact : set = set_artifact

@onready var icon: TextureRect = $Icon
@onready var anim_activate: AnimationPlayer = $AnimActivate


func test() -> void:
	artifact = preload("res://artifacts/explosive_chip.tres")
	await  get_tree().create_timer(2.0).timeout
	flash()

func set_artifact(new_artifact: Artifact) -> void:
	if not is_node_ready():
		await ready
	
	artifact = new_artifact
	icon.texture = artifact.icon

func flash() -> void:
	anim_activate.play("flash")

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		Events.artifact_tooltip_requested.emit(artifact)
		print("Artifact tooltip")
