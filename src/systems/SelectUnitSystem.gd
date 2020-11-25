extends System

func on_process_entity(entity : Entity, delta: float):
	#var _component = entity.get_component("velocity") as Velocity
	#entity.position += 100 * delta
	pass
	

func get_entity_at(entities, position : Vector2):
	for entity in entities:
		var area = entity.get_node("CollisionShape2D").get_shape()
		var entityposition = entity.position
		var dist = position.distance_to(entityposition)
		#print(dist)
		if (dist < area.radius):
			return entity
	
	print("NO entity found")
	return null
	
