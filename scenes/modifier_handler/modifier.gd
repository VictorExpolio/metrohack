class_name Modifier
extends Node
# future for player CREDIT_COST, CARD_DRAW
# future for enemy 
# future for BOTH -> VIRUS, BLOCK_ADDED
enum Type {DMG_DEALT, DMG_TAKEN, CARD_COST, SHOP_COST, NO_MODIFIER, BLOCK_ADDED}
@export var type: Type

func get_value(source_id: String) -> ModifierValue:
	for value: ModifierValue in get_children():
		if value.source_id == source_id:
			return value
	
	return null

func add_new_value(value: ModifierValue) -> void:
	var modifier_value := get_value(value.source_id)
	if not modifier_value:
		add_child(value)
	else:
		modifier_value.flat_value = value.flat_value
		modifier_value.percent_value = value.percent_value

func remove_value(source_id: String) -> void:
	for value: ModifierValue in get_children():
		if value.source_id == source_id:
			value.queue_free()

func clear_values() -> void: #Para limpiar TODOS los valores
	for value: ModifierValue in get_children():
		value.queue_free()

func get_modified_value(base: int) -> int:
	var flat_result: int = base
	#Si no modificamos el porcentaje *1 para dejar la el flat_result
	var percent_result: float = 1.0
	#Aplicar flat_result BEFORE
	for value: ModifierValue in get_children():
		if value.type == ModifierValue.Type.FLAT:
			flat_result += value.flat_value
	#Apply percent_result Modifiers
	for value: ModifierValue in get_children():
		if value.type == ModifierValue.Type.PERCENT_BASED:
			percent_result += value.percent_value
	
	return floori(flat_result * percent_result)
