extends System

# This checks if a unit is in range of the item they want to pick up

func on_process_entity(entity : Entity, delta: float):
	var c : IsUnitComponent = ECS.entity_get_component(entity, "IsUnitComponent")
	if c.to_pickup:
		var eq : Entity = c.to_pickup
		var epos = entity.position
		var opos = eq.position
		if (epos - opos).length() <= 20:
			var main = get_tree().get_root().get_node("Main")
			var iseq : IsEquipmentComponent = ECS.entity_get_component(eq, "IsEquipmentComponent")
			main.append_to_log(c.unit_name + " has picked up " + iseq.eq_name)
			c.carrying.push_back(eq)
			ECS.remove_entity(eq) # so it gets removed from the map
			if c.current_item == null:
				c.current_item = eq
			c.to_pickup = null
		pass

