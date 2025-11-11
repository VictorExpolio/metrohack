class_name ChargedStatus
extends Status

func get_tooltip() -> String:
	return tooltip % stacks

func initialize_status(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)

func _on_status_changed(target: Node) -> void:
	#los assters ponen una condición para que el programa siga funcionando y si paran el programa dan un mensaje
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var dmg_dealt_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DMG_DEALT)
	assert(dmg_dealt_modifier, "No dmg_dealt modifiers on%s" % target)
	
	var charged_modifier_value := dmg_dealt_modifier.get_value("charged")
	
	if not charged_modifier_value:
		charged_modifier_value = ModifierValue.create_new_modifier("charged", ModifierValue.Type.FLAT)
		
	charged_modifier_value.flat_value = stacks
	dmg_dealt_modifier.add_new_value(charged_modifier_value)
