class_name Treasure
extends Control

@export var treasure_artifact_pool: Array[Artifact]
@export var artifact_handler: ArtifactHandler
@export var char_stats: CharacterStats

var found_artifact: Artifact

func generate_artifact() -> void:
	var available_artifacts := treasure_artifact_pool.filter(
		func(artifact: Artifact):
			var can_appear := artifact.can_apper_as_reward(char_stats)
			var already_had_it := artifact_handler.has_artifact(artifact.id)
			return can_appear and not already_had_it
	)
	found_artifact = available_artifacts.pick_random()
	print("the found artifact in the trasure is the %s" %found_artifact.id)


func _on_vault_icon_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		_on_treasure_opened()

func _on_treasure_opened() -> void:
		Events.treasure_room_exited.emit(found_artifact)
