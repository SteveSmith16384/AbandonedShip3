extends System


func on_process_entity(entity : Entity, delta: float):
	var c = ECS.entity_get_component(entity.id, "hasvoicecomponent")
	if c.to_play > 0:
		var sfx = load("res://assets/sfx/voices/sevrina/cduckett-01-ready.wav")
		$AudioStreamPlayer2D.stream = sfx
		$AudioStreamPlayer2D.play()
		c.to_play = 0
	pass
	
