class_name VirusStatus
extends Status

const MODIFIER := 0.5

func apply_status(target: Node) -> void:
	print("Take damage at start turn" % [target, MODIFIER * 100])
	
	var damage_effect := DamageEffect.new()
	damage_effect.amount = duration
	damage_effect.execute([target])
	
	status_applied.emit(self)
