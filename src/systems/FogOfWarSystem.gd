class_name FogOfWarSystem
extends System

func on_process_entity(entity : Entity, delta: float):
	check_if_visible(entity)
	pass


func check_if_visible(enemy):
	var main = get_tree().get_root().get_node("Main")
	var space_rid = main.get_world_2d().space
	var space_state = Physics2DServer.space_get_direct_state(space_rid)
	
	var seen = false
	for unit in main.units.values():
		seen = check_can_see(enemy, unit, main, space_state)
		if seen:
			# Stop moving if an ememy?
			if ECS.entity_has_component(enemy, "isunitcomponent"): # must be an enemy
				# Voice
				if enemy.get_node("Sprite").visible == false:
					if ECS.entity_has_component(unit, "hasvoicecomponent"):
						var hvc = ECS.entity_get_component(unit, "hasvoicecomponent")
						hvc.to_play.push_back(Globals.SPEECH_SEEN_ENEMY)
					
					# Only cancel the destination if it's a new enemy!
					var dc = ECS.entity_get_component(unit, "destinationcomponent")
					if dc:
						dc.has_destination = false
				
			enemy.get_node("Sprite").visible = true
			break;
	
	if not seen:
		enemy.get_node("Sprite").visible = false

		
func check_can_see(enemy, unit, main, space_state):
	var result = space_state.intersect_ray(unit.position, enemy.position, [enemy])
	return result.size() == 0
