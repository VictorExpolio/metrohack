#meta-description: Create a Artifact, passive abilities for the player
class_name CodeDiscount
extends Artifact

@export_range(1, 100) var discount := 25

var artifact_ui : ArtifactUI

func initialize_artifact(owner: ArtifactUI) -> void:
	Events.shop_entered.connect(add_shop_modifier)
	artifact_ui = owner

func deactivate_artifact(_owner: ArtifactUI) -> void:
	Events.shop_entered.disconnect(add_shop_modifier)

func add_shop_modifier(shop: Shop) -> void:
	artifact_ui.flash()

	var shop_cost_modifier := shop.modifier_handler.get_modifier(Modifier.Type.SHOP_COST)
	assert(shop_cost_modifier, "No shop modifier")
	
	var coupons_modifier_value := shop_cost_modifier.get_value("code_discount")
	if not coupons_modifier_value:
		coupons_modifier_value = ModifierValue.create_new_modifier("code_discount", ModifierValue.Type.PERCENT_BASED)
		coupons_modifier_value.percent_value = -1 * discount / 100.0
		shop_cost_modifier.add_new_value(coupons_modifier_value)

func get_tooltip() -> String:
	return tooltip
