extends System

func on_process_entity(entity : Entity, delta: float):
	var c = ECS.entity_get_component(entity.id, "destinationcomponent")

	if c.has_destination:
		if (c.destination - entity.position).length() > 5:
			var s = ECS.entity_get_component(entity.id, "canmovecomponent")
			var velocity = (c.destination - entity.position).normalized() * s.speed
			var new_velocity = entity.move_and_slide(velocity)
			#c.has_destination = false
		else:
			c.has_destination = false
	pass
	
