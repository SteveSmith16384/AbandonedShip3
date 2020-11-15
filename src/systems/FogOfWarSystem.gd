class_name FogOfWarSystem
extends System

func on_process_entity(entity : Entity, delta: float):
	#var c = ECS.entity_get_component(entity.id, "destinationcomponent")
	check_if_visible(entity)
	pass


func check_if_visible(enemy):
	var main = get_tree().get_root().get_node("Main")
	var space_rid = main.get_world_2d().space
	var space_state = Physics2DServer.space_get_direct_state(space_rid)
	
	enemy.get_node("Sprite").visible = false
	for unit in main.units.values():
		var result = check_can_see(enemy, unit, main, space_state)
		if result:
			# Stop moving
			var dc = ECS.entity_get_component(unit.id, "destinationcomponent")
			if dc:
				dc.has_destination = false
				
			# Voice
			if enemy.get_node("Sprite").visible == false:
				if ECS.entity_has_component(unit.id, "hasvoicecomponent"):
					var hvc = ECS.entity_get_component(unit.id, "hasvoicecomponent")
					hvc.to_play = 3
					
			enemy.get_node("Sprite").visible = true
			break;
		
		
func check_can_see(enemy, unit, main, space_state):
	var result = space_state.intersect_ray(unit.position, enemy.position, [enemy])
	return result.size() == 0
		#var idx = unit.get_node("CollisionShape2D")
		#var parent = result.collider.get_owner()
		#if (result.collider == idx):
		#enemy.get_node("Sprite").visible = false
		#return
		
	#enemy.get_node("Sprite").visible = true
		
