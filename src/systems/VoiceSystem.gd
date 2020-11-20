extends System

func on_process_entity(entity : Entity, delta: float):
	var c = ECS.entity_get_component(entity, "hasvoicecomponent")
	if c.to_play > 0:
		var sfx
		match c.to_play:
			Globals.SPEECH_READY:
				sfx = load("res://assets/sfx/voices/sevrina/cduckett-01-ready.wav")
			Globals.SPEECH_OK:
				sfx = load("res://assets/sfx/voices/sevrina/cduckett-03-roger.wav")
			Globals.SPEECH_SEEN_ENEMY:
				sfx = load("res://assets/sfx/voices/sevrina/cduckett-04-taking_fire.wav")
			Globals.SPEECH_DIED:
				sfx = load("res://assets/sfx/voices/sevrina/cduckett-05-scream.wav")

		$AudioStreamPlayer2D.stream = sfx
		$AudioStreamPlayer2D.play()
		c.to_play = 0
	pass
	
