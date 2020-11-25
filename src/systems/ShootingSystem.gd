class_name ShootingSystem
extends System

# todo - only check every so often
func on_process_entity(entity : Entity, delta: float):
	var cbs = ECS.entity_get_component(entity, "isunitcomponent")
	if cbs.is_alive == false:
		return

	if cbs.next_shot_time > OS.get_unix_time():
		return
		
	if cbs.current_item == null:
		return
		
	var item = cbs.current_item
	var iseq = ECS.entity_get_component(item, "isequipmentcomponent")
	if iseq.can_shoot == false:
		return
		
	var main = get_tree().get_root().get_node("Main")
	var space_rid = main.get_world_2d().space
	var space_state = Physics2DServer.space_get_direct_state(space_rid)

	if cbs.current_target != null:
		if is_valid_target(entity, cbs.current_target, main, space_state):
			main.append_to_log(cbs.unit_name + " is shooting")
			shoot_at(entity, cbs.current_target, iseq)
			main.play_sfx("burst fire_reduced.wav")
			cbs.next_shot_time = OS.get_unix_time() + Settings.SHOT_INTERVAL_SECS
		else:
			cbs.current_target = null
	else:
		cbs.current_target = check_for_targets(entity, main, space_state)
	pass


func check_for_targets(shooter, main, space_state):
	for target_id in ECS.component_entities["isunitcomponent"]:
		if ECS.has_entity(target_id): # In case removed by shot
			var target = ECS.entities[target_id]
			if is_valid_target(shooter, target, main, space_state):
				return target

	return null
	
		
func is_valid_target(shooter, target, main, space_state):
	if shooter == target:
		return false
		
	var scbs = ECS.entity_get_component(shooter, "isunitcomponent")
	var tcbs = ECS.entity_get_component(target, "isunitcomponent")
	if scbs.side == tcbs.side or tcbs.is_alive == false:
		return false
		
	var result = space_state.intersect_ray(shooter.position, target.position, [target])
	return result.size() == 0
	# todo - check distance?


func shoot_at(shooter, target, eqc):
	#var scbs = ECS.entity_get_component(shooter, "isunitcomponent")
	var tcbs = ECS.entity_get_component(target, "isunitcomponent")
	
	var damage = eqc.shot_power
	tcbs.damage_this_loop = damage
	pass


