extends System

func on_process_entity(entity : Entity, delta: float):
	var blip = ECS.entity_get_component(entity, "isblipcomponent")
	blip.scale = blip.scale + (delta * blip.diff * 1.5)
	if blip.scale < 0.5:
		blip.scale = 0.5
		blip.diff = 1
	elif blip.scale > 1:
		blip.scale = 1
		blip.diff = -1
		
	var sprite : Sprite = entity.get_node("Sprite")
	sprite.scale.x = blip.scale
	sprite.scale.y = blip.scale
	pass
