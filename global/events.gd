#Autoload class_name : Events
extends Node

#Card related events
signal  card_drag_started(card_ui : CardUI)
signal  card_drag_ended(card_ui : CardUI)
signal  card_aim_started(card_ui : CardUI)
signal  card_aim_ended(card_ui : CardUI)
signal  card_played(card : Card)
signal  card_tooltip_requested(card : Card)
signal  tooltip_hide_requested

#Player related events
signal player_hand_drawn
signal player_hand_discarded
signal player_turn_ended
signal player_hurt
signal player_died

#Enemy-related events
signal enemy_action_completed(enemy: Enemy)
signal enemy_turn_ended
signal enemy_died(enemy: Enemy)

#Battle-related events
signal battle_over_screen_requested(text : String, type: BattleOverPanel.Type)
signal battle_won
signal status_tooltip_requested(statuses: Array[Status])

#Map-related events
signal map_exited(room : Room)

#Shop-related events
signal shop_entered(shop: Shop)
signal shop_artifact_bought(artifact: Artifact, money_cost: int)
signal shop_card_bought(card: Card, money_cost: int)
signal shop_exited

#Campfire-related events
signal campfire_exited

#Battle Reward-related events
signal battle_reward_exited

#Treasure-related events
signal treasure_room_exited(found_artifact : Artifact)

#EventRoom-related events
signal event_room_exited

#Artifact-related events
signal artifact_tooltip_requested(artifact: Artifact)
