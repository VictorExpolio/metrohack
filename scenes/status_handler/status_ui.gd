class_name StatusUI
extends Control

@export var status: Status : set = set_status

@onready var icon: TextureRect = $Icon
@onready var duration: Label = $Duration
@onready var stacks: Label = $Stacks

func _ready() -> void:
	pass
	#test_status()

func test_status() -> void:
	print(str("test_status"))
	await  get_tree().create_timer(2).timeout
	print(str("test_status POST-AWAIT"))
	status.duration += 1
	await  get_tree().create_timer(1).timeout
	print(str("test_status POST-POST-AWAIT"))
	status.duration -= 1
	status.stacks += 2

func set_status(new_status: Status) -> void:
	if not is_node_ready():
		await  ready
	
	status = new_status
	icon.texture = status.icon
	duration.visible = status.stack_type == Status.StackType.DURATION
	stacks.visible = status.stack_type == Status.StackType.INTENSITY
	#Tocamos propiedaddes del nodo control
	custom_minimum_size = icon.size
	
	if duration.visible:
		custom_minimum_size = duration.size + duration.position
	elif stacks.visible:
		custom_minimum_size = stacks.size + stacks.position
	
	if not status.status_changed.is_connected(_on_status_changed):
		status.status_changed.connect(_on_status_changed)
	
	_on_status_changed()

func _on_status_changed() -> void:
	if not status:
		return
		
	if status.can_expire and status.duration <= 0:
		queue_free()
	#aqui solo borramos si es 0 pero OJO porque si que puede ser MENOS -1
	if status.stack_type == Status.StackType.INTENSITY and status.stacks == 0:
		queue_free()
	
	duration.text = str(status.duration)
	stacks.text = str(status.stacks)
	
	
	
