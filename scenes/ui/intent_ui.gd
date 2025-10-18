class_name IntentUI
extends HBoxContainer


@onready var icon: TextureRect = $Icon
@onready var number: Label = $Number

func update_intent(intent : Intent) -> void:
	if not intent:
		hide()
		return
	
	icon.texture = intent.icon
	icon.visible = icon.texture != null
	number.text = str(intent.number)
	#solo se muestra si el num es positivo, hay intents sin num por ejemplo block
	number.visible = intent.number.length() > 0
	show()
