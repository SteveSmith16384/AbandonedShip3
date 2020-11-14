extends System

# 1 = Ready
# 2 = OK
# 3 = Seen enemy
# 4 = Scream

func on_process_entity(entity : Entity, delta: float):
	var c = ECS.entity_get_component(entity.id, "hasvoicecomponent")
	if c.to_play > 0:
		var sfx
		match c.to_play:
			1:
				sfx = load("res://assets/sfx/voices/sevrina/cduckett-01-ready.wav")
			2:
				sfx = load("res://assets/sfx/voices/sevrina/cduckett-03-roger.wav")
			3:
				sfx = load("res://assets/sfx/voices/sevrina/cduckett-04-taking_fire.wav")
			4:
				sfx = load("res://assets/sfx/voices/sevrina/cduckett-05-scream.wav")

		$AudioStreamPlayer2D.stream = sfx
		$AudioStreamPlayer2D.play()
		c.to_play = 0
	pass
	
