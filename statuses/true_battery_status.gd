class_name TrueBatteryStatus
extends Status

const CHARGED_STATUS = preload("res://statuses/charged.tres")

var stacks_per_turn := 1

func apply_status(target: Node) -> void:
	print("Apply true battery")
	var status_effect := StatusEffect.new()
	var charged := CHARGED_STATUS.duplicate()
	charged.stacks = stacks_per_turn
	status_effect.status = charged
	status_effect.execute([target])
	
	status_applied.emit(self)
