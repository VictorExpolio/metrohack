class_name ArtifactTooltip
extends Control

@onready var artifact_icon: TextureRect = %ArtifactIcon

@onready var artifact_title: Label = %ArtifactTitle
@onready var artifact_description: RichTextLabel = %ArtifactDescription
@onready var artifact_flavour: RichTextLabel = %ArtifactFlavour

@onready var back_button: Button = %BackButton

func _ready() -> void:
	back_button.pressed.connect(hide)
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and visible:
		hide()

func show_tooltip(artifact: Artifact) -> void:
	artifact_icon.texture = artifact.icon
	artifact_title.text = artifact.artifact_name
	artifact_flavour.text = artifact.flavour_tooltip
	artifact_description.text = artifact.get_tooltip()
	show()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse") and visible:
		hide()
