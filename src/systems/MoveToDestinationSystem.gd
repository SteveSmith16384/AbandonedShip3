extends System

func on_process_entity(entity : Entity, delta: float):
	entity.position.x += 100 * delta
	pass
	
