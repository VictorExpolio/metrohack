class_name ShopArtifact
extends VBoxContainer

const ARTIFACT_UI = preload("res://scenes/artifact_handler/artifact_ui.tscn")

@export var artifact : Artifact : set = set_artifact
@onready var artifact_container: CenterContainer = %ArtifactContainer
@onready var price: HBoxContainer = %Price
@onready var price_label: Label = %PriceLabel
@onready var buy_button: Button = %BuyButton

@onready var money_cost : int = randi_range(80, 130)

func set_artifact(new_artifact: Artifact) -> void:
	if not is_node_ready():
		await  ready
	artifact = new_artifact
	
	for artifact_ui : ArtifactUI in artifact_container.get_children():
		artifact_ui.queue_free()
	
	var new_artifact_ui := ARTIFACT_UI.instantiate() as ArtifactUI
	artifact_container.add_child(new_artifact_ui)
	new_artifact_ui.artifact = artifact

func update(run_stats: RunStats) -> void:
	if not artifact_container or not price or not buy_button:
		return
	
	price_label.text = str(money_cost)
	
	if run_stats.money > money_cost:
		price_label.remove_theme_color_override("font_color")
		buy_button.disabled = false
	else:
		price_label.add_theme_color_override("font_color", Color.RED)
		buy_button.disabled = true

func _on_buy_button_pressed() -> void:
	Events.shop_artifact_bought.emit(artifact, money_cost)
	artifact_container.queue_free()
	price.queue_free()
	buy_button.queue_free()
