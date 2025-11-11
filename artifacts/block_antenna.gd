#meta-description: Create a Artifact, passive abilities for the playerc
extends Artifact

@export var block_bonus := 2

func activate_artifact(owner: ArtifactUI) -> void:
	var player := owner.get_tree().get_nodes_in_group("player")
	var block_effect := BlockEffect.new()
	block_effect.amount = block_bonus
	#block_effect.receiver_modifier_type = Modifier.Type.NO_MODIFIER
	block_effect.execute(player)
	
	owner.flash()

func get_tooltip() -> String:
	return tooltip
