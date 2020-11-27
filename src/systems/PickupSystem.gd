extends System

# This checks if a unit is in range of the item they want to pick up

func on_process_entity(entity : Entity, delta: float):
	var c = ECS.entity_get_component(entity, "isunitcomponent")
	if c.to_pickup:
		var epos = entity.position
		var opos = c.to_pickup.position
		if (epos - opos).length() <= 20:
			var main = get_tree().get_root().get_node("Main")
			main.append_to_log(c.unit_name + " has picked up " + c.to_pickup.name)
			ECS.remove_entity(c.to_pickup)
			c.to_pickup = null
		pass

