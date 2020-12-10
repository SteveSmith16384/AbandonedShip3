extends System

func on_process_entity(entity : Entity, delta: float):
	var c = ECS.entity_get_component(entity, "hasvoicecomponent")
	if c.to_play.empty() == false:
		var sfx
		var id = c.to_play.pop_front()
		match id:
			Globals.SPEECH_READY:
				sfx = load("res://assets/sfx/voices/hazel/hazel_ready.wav")
			Globals.SPEECH_ON_MY_WAY:
				sfx = load("res://assets/sfx/voices/hazel/hazel_on_my_way.wav")
			Globals.SPEECH_IVE_ARRIVED:
				sfx = load("res://assets/sfx/voices/hazel/hazel_im_here.wav")
			Globals.SPEECH_SEEN_ENEMY:
				sfx = load("res://assets/sfx/voices/hazel/hazel_something_here.wav")
			Globals.SPEECH_DIED:
				sfx = load("res://assets/sfx/voices/hazel/cduckett-05-scream.wav")
			_:
				print("No such voice: " + str(id))
				
		$AudioStreamPlayer2D.stream = sfx
		$AudioStreamPlayer2D.play()
	pass
	
