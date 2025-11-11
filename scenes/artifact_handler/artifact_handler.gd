class_name ArtifactHandler
extends HBoxContainer

signal artifacts_activated(type: Artifact.Type)

const ARTIFACT_APPLY_INTERVAL := 0.5
const ARTIFACT_UI = preload("res://scenes/artifact_handler/artifact_ui.tscn")

@onready var artifacts_control: ArtifactsControl = $ArtifactsControl
@onready var artifacts: HBoxContainer = %Artifacts

func _ready() -> void:
	artifacts.child_exiting_tree.connect(_on_artifacts_child_exiting_tree)
	#test_relics()

func test_relics() -> void:
	add_artifact(preload("res://artifacts/explosive_chip.tres"))
	await get_tree().create_timer(2.0).timeout
	add_artifact(preload("res://artifacts/block_antenna.tres"))
	await get_tree().create_timer(2.0).timeout
	add_artifact(preload("res://artifacts/explosive_chip.tres"))

func activate_artifacts_by_type(type: Artifact.Type) -> void:
	if type == Artifact.Type.EVENT_BASED:
		return
	
	var artifact_queue: Array[ArtifactUI] = _get_all_artifact_ui_nodes().filter(
		func(artifact_ui: ArtifactUI):
			return artifact_ui.artifact.type == type
	)
	if artifact_queue.is_empty():
		artifacts_activated.emit(type)
		return
	
	#Tween para la cascada de activaciones de artifacts
	var tween := create_tween()
	for artifact_ui: ArtifactUI in artifact_queue:
		tween.tween_callback(artifact_ui.artifact.activate_artifact.bind(artifact_ui))
		#tween.tween_callback(artifact_ui.artifacts_activated.bind(artifact_ui))
		tween.tween_interval(ARTIFACT_APPLY_INTERVAL)
	
	tween.finished.connect(func(): artifacts_activated.emit(type))

func add_artifacts(artifacts_array: Array[Artifact]) -> void:
	for artifact: Artifact in artifacts_array:
		add_artifact(artifact)

func add_artifact(artifact: Artifact) -> void:
	if has_artifact(artifact.id):
		return
	
	var new_artifact_ui := ARTIFACT_UI.instantiate() as ArtifactUI
	artifacts.add_child(new_artifact_ui)
	new_artifact_ui.artifact = artifact
	new_artifact_ui.artifact.initialize_artifact(new_artifact_ui)

func has_artifact(id : String) -> bool:
	for artifact_ui: ArtifactUI in artifacts.get_children():
		if artifact_ui.artifact.id == id and is_instance_valid(artifact_ui):
			return true
	
	return false

func _get_all_artifacts() -> Array[Artifact]:
	var artifact_ui_nodes := _get_all_artifact_ui_nodes()
	var artifacts_array : Array[Artifact] = []
	
	for artifact_ui: ArtifactUI in artifact_ui_nodes:
		artifact_ui.append(artifact_ui.artifact)
	
	return artifacts_array

func _get_all_artifact_ui_nodes() -> Array[ArtifactUI]:
	var all_artifacts : Array[ArtifactUI] = []
	
	for artifact_ui: ArtifactUI in artifacts.get_children():
		all_artifacts.append(artifact_ui)
	return all_artifacts

func _on_artifacts_child_exiting_tree(artifact_ui: ArtifactUI) -> void:
	if not artifact_ui:
		return
	
	if artifact_ui.artifact:
		artifact_ui.artifact.deactivate_artifact(artifact_ui)
