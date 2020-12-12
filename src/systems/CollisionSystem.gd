class_name CollisionSystem
extends System

func on_process_entity(entity : Entity, delta: float):
	# Do nothing
	pass
	
	
func collision(mover2, with2, blocks: bool):
	var mover = mover2
	while mover is Entity == false:
		mover = mover.get_owner()
		if mover == null:
			return
			
	var with = with2
	while with is Entity == false:
		with = with.get_owner()
		if with == null:
			break; # it may be the floor, for when barrels land on floor?
			
		
	process_collision(mover, with, blocks)	
	pass
	

func process_collision(mover : Entity, other : Entity, blocks: bool):
	if ECS.entity_has_component(mover, "HarmsUnitComponent"):
		if other && ECS.entity_has_component(other, "IsUnitComponent"):
			var main = get_tree().get_root().get_node("Main")
			main.unit_harmed(other)
	if other && ECS.entity_has_component(other, "HarmsUnitComponent"):
		if ECS.entity_has_component(mover, "IsUnitComponent"):
			var main = get_tree().get_root().get_node("Main")
			main.unit_harmed(mover)
	
	if ECS.entity_has_component(mover, "removeoncollisioncomponent"):
		ECS.remove_entity(mover)
	if other && ECS.entity_has_component(other, "removeoncollisioncomponent"):
		ECS.remove_entity(other)

	if blocks:
		var mv = ECS.entity_get_component(mover, "CanMoveComponent")
		mover.position = mv.prev_pos
		var c = ECS.entity_get_component(mover, "destinationcomponent")
		c.has_destination = false
	
	# Doors
	if other && ECS.entity_has_component(other, "IsDoorComponent"):
		var door = ECS.entity_get_component(other, "IsDoorComponent")
		door.touched = true
	pass
