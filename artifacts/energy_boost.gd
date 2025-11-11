#meta-description: Create a Artifact, passive abilities for the playerc
extends Artifact

@export var energy_amount := 1

func activate_artifact(owner: ArtifactUI) -> void:
	Events.player_hand_drawn.connect(_add_mana_energy_artifact.bind(owner), CONNECT_ONE_SHOT)

func _add_mana_energy_artifact(owner: ArtifactUI):
	owner.flash()
	var player := owner.get_tree().get_first_node_in_group("player") as Player
	if player:
		#player.stats.heal(heal_amount)
		player.stats.add_mana(energy_amount)
		

func get_tooltip() -> String:
	return tooltip
