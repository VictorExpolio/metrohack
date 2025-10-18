#autoload class_name SFX_PLAYER
extends Node

func play(audio : AudioStream, single = false) -> void:
	if not audio:
		return
		
	if single:
		stop()
	
	for audio_player : AudioStreamPlayer in get_children():
		if not audio_player.playing:
			audio_player.stream = audio
			audio_player.play()
			break
	
func stop() -> void:
	for audio_player : AudioStreamPlayer in get_children():
		audio_player.stop()
