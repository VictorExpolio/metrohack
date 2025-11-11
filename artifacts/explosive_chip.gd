#meta-description: Create a Artifact, passive abilities for the playerc
extends Artifact
#class_name ExplosiveChip

@export var damage := 2

func activate_artifact(owner: ArtifactUI) -> void:
	var enemies := owner.get_tree().get_nodes_in_group("enemies")
	var damage_effect := DamageEffect.new()
	damage_effect.amount = damage
	damage_effect.receiver_modifier_type = Modifier.Type.NO_MODIFIER
	damage_effect.execute(enemies)
	
	owner.flash()


func get_tooltip() -> String:
	return tooltip
