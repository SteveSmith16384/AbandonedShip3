extends System

func on_process_entity(entity : Entity, delta: float):
	var cbs = ECS.entity_get_component(entity.id, "isunitcomponent")
	if cbs.is_alive == false:
		return
	
	if cbs.damage_this_loop == 0:
		return
		
	cbs.health -= cbs.damage_this_loop
	cbs.damage_this_loop = 0
	
	if cbs.health <= 0:
		cbs.is_alive = false
		ECS.remove_entity(entity)

		var main = get_tree().get_root().get_node("Main")
		#main.append_to_log(tcbs.unit_name + " killed")
		main.entity_killed(entity, cbs)
	pass



