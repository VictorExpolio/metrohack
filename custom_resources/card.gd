class_name Card
extends Resource

enum Type {ATTACK, SKILL, POWER}
enum Rarity {COMMON, UNCOMMON, RARE} #maybe starters too? and specials out of the pool
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

#Provisional? quizá cambiar por texturas
const RARITY_COLORS := {
	Card.Rarity.COMMON: Color.GRAY,
	Card.Rarity.UNCOMMON: Color.AQUAMARINE,
	Card.Rarity.RARE: Color.ORANGE,
}

@export_group("Card Attributes")
@export var id : String
@export var type : Type
@export var rarity : Rarity
@export var target : Target
@export var cost : int
@export var trashes: bool = false
# credit_cost
@export var credit_cost : int
@export var money_cost : int


@export_group("Card Visuals")
@export var icon : Texture
@export_multiline var tooltip_text : String
@export var sound : AudioStream

func is_single_targeted() -> bool:#devuelve true al == y al resto false
	return target == Target.SINGLE_ENEMY
	
func _get_targets(targets : Array[Node]) -> Array[Node]:
	if not targets:
		return[]
		
	var tree := targets[0].get_tree()
	
	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("enemies")
		Target.EVERYONE:
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("enemies") 
		_:
			return []

func play(targets: Array[Node], char_stats: CharacterStats, modifiers: ModifierHandler) -> void:
	Events.card_played.emit(self)
	char_stats.mana -= cost
	
	if is_single_targeted():
		apply_effects(targets, modifiers)
	else:
		apply_effects(_get_targets(targets), modifiers)
	
func apply_effects(_targets: Array[Node], _modifiers: ModifierHandler) -> void:
	pass
	
func get_default_tooltip() -> String:
	return tooltip_text
	
func get_update_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text

#test function
func get_money_cost() -> int:
	return money_cost
