class_name RunStats
extends Resource

signal money_changed

const STARTING_MONEY := 70

#Card Rewards var
const BASE_CARD_REWARDS := 3
const BASE_COMMON_WEIGHT := 5
const BASE_UNCOMMON_WEIGHT := 4.2
const BASE_RARE_WEIGHT := 0.8

@export var money : int = STARTING_MONEY : set = set_money

@export var card_rewards := BASE_CARD_REWARDS
@export_range(0.0, 10.0) var common_weight := BASE_COMMON_WEIGHT
@export_range(0.0, 10.0) var uncommon_weight := BASE_UNCOMMON_WEIGHT
@export_range(0.0, 10.0) var rare_weight := BASE_RARE_WEIGHT

func set_money(new_amount : int) -> void:
	money = new_amount
	money_changed.emit()

func reset_weights() -> void:
	common_weight = BASE_COMMON_WEIGHT
	uncommon_weight = BASE_UNCOMMON_WEIGHT
	rare_weight = BASE_RARE_WEIGHT
