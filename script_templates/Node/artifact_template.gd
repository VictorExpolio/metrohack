# meta-name: Artifact
#meta-description: Create a Artifact, passive abilities for the playerc
extends Artifact

var member_var := 0

func initialize_artifact(_owner: ArtifactUI) -> void:
	print("obtain a artifact")

func activate_artifact(_owner: ArtifactUI) -> void:
	print("activate WHEN Artifact.Type spcefically marks it")

#
func deactivate_artifact(_owner: ArtifactUI) -> void:
	print("when a artifact exits the tree, artifact removed")
	print("for EVENT type artifacts, disconnect from EventBus")

func get_tooltip() -> String:
	return tooltip
