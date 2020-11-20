extends Node


func create_player_unit(main, name: String, position):
	var unit = load("res://entities/UnitEntity.tscn")
	
	var syylk = unit.instance()
	main.add_child(syylk)
	syylk.position = position
	var syylk_img = load("res://assets/sprites/" + name + ".png")
	syylk.get_node("Sprite").set_texture(syylk_img)
	
	var g = load("res://equipment/Pistol.tscn")
	var gun = g.instance()
	main.add_child(gun)

	var scbs = ECS.entity_get_component(syylk, "isunitcomponent")
	scbs.unit_name = name
	scbs.current_item = gun
	
	var eq = ECS.entity_get_component(syylk, "cancarrycomponent")
	eq.carrying.append(gun)
	
	return syylk


func create_enemy_unit(main, name: String, position):
	var unit = load("res://entities/EnemyEntity.tscn")
	
	var syylk = unit.instance()
	main.add_child(syylk)
	syylk.position = position
	var syylk_img = load("res://assets/sprites/" + name + ".png")
	syylk.get_node("Sprite").set_texture(syylk_img)
	
	var g = load("res://equipment/Pistol.tscn")
	var gun = g.instance()
	main.add_child(gun)

	var scbs = ECS.entity_get_component(syylk, "isunitcomponent")
	scbs.unit_name = name
	scbs.current_item = gun
	
	#var eq = ECS.entity_get_component(syylk, "cancarrycomponent")
	#eq.carrying.append(gun)
	
	return syylk

