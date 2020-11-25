extends System

func on_process_entity(entity : Entity, delta: float):
	var c = ECS.entity_get_component(entity, "destinationcomponent")

	if c.has_destination:
		if (c.destination - entity.position).length() > 5:
			var s = ECS.entity_get_component(entity, "canmovecomponent")
			var velocity = (c.destination - entity.position).normalized() * s.speed
			var new_velocity = entity.move_and_slide(velocity)
		else:
			var unit = ECS.entity_get_component(entity, "isunitcomponent")
			var main = get_tree().get_root().get_node("Main")
			main.append_to_log(unit.unit_name + " has arrived")

			c.has_destination = false
	pass
	
