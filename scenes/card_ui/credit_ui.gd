class_name CreditUI
extends Panel

@export var char_stats : CharacterStats : set = _set_char_stats

@onready var credit_label: Label = %CreditLabel


func _ready() -> void:
	char_stats.credit = 5
	#await  get_tree().create_timer(1).timeout
	#char_stats.mana = char_stats.mana 
	pass
	

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	#char_stats = value.create_instance()
	#OJO el punto.create_instance??
	if not char_stats.stats_changed.is_connected(_on_stats_changed):
		char_stats.stats_changed.connect(_on_stats_changed)
	
	if not is_node_ready():
		await ready
		
	_on_stats_changed()

func _on_stats_changed() -> void:
	#mana_label.text = "%s/%s" %[char_stats.mana, char_stats.max_mana]
	#credit_label.text = "%s/%s" % char_stats.credit
	#credit_label.text = "%s" % char_stats.credit
	credit_label.text = "%s" %char_stats.credit
	
