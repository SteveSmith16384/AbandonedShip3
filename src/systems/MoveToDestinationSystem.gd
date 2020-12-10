extends System

func on_process_entity(entity : Entity, delta: float):
	var c = ECS.entity_get_component(entity, "destinationcomponent")

	if c.has_destination:
		if (c.destination - entity.position).length() > 5:
			var s = ECS.entity_get_component(entity, "CanMovecomponent")
			s.prev_pos = entity.position
			var velocity = (c.destination - entity.position).normalized() * s.speed
			var new_velocity = entity.move_and_slide(velocity)
		else:
			var unit = ECS.entity_get_component(entity, "isunitcomponent")
			var main = get_tree().get_root().get_node("Main")
			main.append_to_log(unit.unit_name + " has arrived")

			if ECS.entity_has_component(entity, "hasvoicecomponent"):
				var hvc = ECS.entity_get_component(entity, "hasvoicecomponent")
				hvc.to_play.push_back(Globals.SPEECH_IVE_ARRIVED)

			c.has_destination = false
	pass
	
