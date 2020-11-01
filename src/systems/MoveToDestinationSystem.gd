extends System

const speed = 100

func on_process_entity(entity : Entity, delta: float):
	var c = ECS.entity_get_component(entity.id, "destinationcomponent")
	# rotation = velocity.angle()
	if (c.destination - entity.position).length() > 5:
		var velocity = (c.destination - entity.position).normalized() * speed
		#var new_velocity = entity.$Kine move_and_slide(velocity)
		entity.position += velocity * delta
	#else:
		#c.destination = null
	pass
	
