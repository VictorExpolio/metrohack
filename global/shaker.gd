#Autoload : class_name Shaker
extends Node

func shake(thing: Node2D, strenght : float, duration : float = 0.2) -> void:
	if not thing:
		return
	
	var orig_pos : Vector2 = thing.position
	var shake_count : int = 8
	var tween : Tween = create_tween()
	
	
	for i in shake_count:
		var shake_offset := Vector2(randf_range(-1.0, 1.0),randf_range(-1.0, 1.0))
		var target := orig_pos + strenght * shake_offset
		if i % 2 == 0: #each second loop vuelta al orig_pos
			target = orig_pos
		tween.tween_property(thing, "position", target, duration / float(shake_count))
		strenght *= 0.75
	
	tween.finished.connect(func(): thing.position = orig_pos)
