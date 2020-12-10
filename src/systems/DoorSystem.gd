class_name DoorSystem
extends System

const SECS_TO_OPEN = 1
const SECS_STAY_OPEN = 5


func on_process_entity(entity : Entity, delta: float):
	var door : IsDoorComponent = ECS.entity_get_component(entity, "IsDoorComponent")
	if door.touched:
		door.touched = false
		if door.opening == false:
			var main : Main = get_tree().get_root().get_node("Main")
			main.play_sfx("iron_door.wav")
			door.opening = true

	if door.opening:
		door.time_spent_opening += delta
		if door.time_spent_opening >= SECS_STAY_OPEN:
			door.opening = false
	else:
		door.time_spent_opening -= delta
		if door.time_spent_opening < 0:
			door.time_spent_opening = 0
	
	# Set blocks
	var coll : CollidesComponent = entity.get_node("CollidesComponent")
	coll.blocks = door.time_spent_opening < SECS_TO_OPEN
	
