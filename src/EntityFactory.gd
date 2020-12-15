extends Node


func create_player_unit(main : Main, name: String, position : Vector2):
	var unit = load("res://entities/UnitEntity.tscn")
	
	var syylk = unit.instance()
	main.add_child(syylk)
	syylk.position = position
	var blip = load("res://assets/sprites/greenblip.png")
	syylk.get_node("Sprite").set_texture(blip)

	# Re-add to give a gun
	#var g = load("res://equipment/Pistol.tscn")
	#var gun = g.instance()
	#main.add_child(gun)

	var scbs = ECS.entity_get_component(syylk, "isunitcomponent")
	scbs.unit_name = name
	#scbs.current_item = gun
	
	#var eq = ECS.entity_get_component(syylk, "cancarrycomponent")
	#eq.carrying.append(gun)
	
	return syylk


func create_enemy_unit(main : Main, name: String, position : Vector2):
	var unit = load("res://entities/EnemyEntity.tscn")
	
	var alien = unit.instance()
	main.add_child(alien)
	alien.position = position

	var scbs = ECS.entity_get_component(alien, "isunitcomponent")
	scbs.unit_name = name

	return alien


func create_gun(main : Main, position : Vector2):
	var unit = load("res://entities/EquipmentEntity.tscn")
	
	var eq = unit.instance()
	main.add_child(eq)
	eq.position = position
	
	var iseq : IsEquipmentComponent = ECS.entity_get_component(eq, "IsEquipmentComponent")
	iseq.eq_name = "Gun"
	iseq.can_shoot = true
	
	eq.get_node("Sprite/Label").text = iseq.eq_name
	return eq
