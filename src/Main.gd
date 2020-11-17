extends Node

var selected_unit : Entity
var units = {}
var screen_size


func _ready():
	create_units()
	screen_size = get_viewport().size
	append_to_log("Ready!")
	
	
func create_units():
	var start_pos = get_node("StartLocation")
	
	var syylk = create_unit("zark", start_pos)
	create_unit("syylk", start_pos)
	create_unit("sevrina", start_pos)
	create_unit("torik", start_pos)
	create_unit("manto", start_pos)
	create_unit("maul", start_pos)
	
	selected_unit = syylk
	pass
	

func create_unit(name, start_pos):
	var unit = load("res://entities/UnitEntity.tscn")
	
	var syylk = unit.instance()
	add_child(syylk)
	syylk.position = start_pos.position
	var syylk_img = load("res://assets/sprites/" + name + ".png")
	syylk.get_node("Sprite").set_texture(syylk_img)
	
	var scbs = ECS.entity_get_component(syylk.id, "isunitcomponent")
	scbs.unit_name = name
	
	#  Add button icon
	var b = load("res://gui/UnitSelectorButton.tscn")
	var button = b.instance()
	button.unit = syylk
	button.text = name
	button.icon = syylk_img
	var node = get_node("HUD/UnitSelector/MarginContainer/VBoxContainer")
	node.add_child(button)
	
	units[name] = syylk
	
	# Give the units a destination so they space out
	#var c = ECS.entity_get_component(syylk.id, "destinationcomponent")
	#c.destination = syylk.position
	#c.destination.y += 10
	#c.has_destination = true

	return syylk
	
	
func _process(delta):
	ECS.update()
	
	if selected_unit:
		$Camera2D.position = selected_unit.position

	pass
	
	
func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		#print("Mouse Click/Unclick at: ", event.position)
		if event.button_index == 1:
			var e = getEntityAtPosition(event.position)
			if e:
				select_unit_by_entity(e)
		elif event.button_index == 2 and selected_unit:
			setDestination(event.position)
	pass
	

func getEntityAtPosition(position : Vector2):
	var system = ECS.systems.get("selectunitsystem")
	var entities = ECS.system_entities["selectunitsystem"]
	var pos = Vector2(position)
	pos.x += $Camera2D.position.x - screen_size.x/2
	pos.y += $Camera2D.position.y - screen_size.y/2
	var e = system.get_entity_at(entities, pos)
	return e
	pass


func setDestination(position : Vector2):
	var pos = Vector2(position)
	pos.x += $Camera2D.position.x - screen_size.x/2
	pos.y += $Camera2D.position.y - screen_size.y/2
	var c = ECS.entity_get_component(selected_unit.id, "destinationcomponent")
	c.destination = pos
	c.has_destination = true
	
	# Do voice
	if ECS.entity_has_component(selected_unit.id, "hasvoicecomponent"):
		var hv = ECS.entity_get_component(selected_unit.id, "hasvoicecomponent")
		hv.to_play = 2 # todo - enum
	

func select_unit_by_name(name):
	select_unit_by_entity(units[name])
	
	
func select_unit_by_entity(e):
	selected_unit = e
	if ECS.entity_has_component(selected_unit.id, "hasvoicecomponent"):
		var c = ECS.entity_get_component(selected_unit.id, "hasvoicecomponent")
		c.to_play = 1 # todo - enum
	pass


func append_to_log(text : String):
	var l = get_node("HUD/GameLog")
	l.append(text)
	pass


func entity_killed(e, iuc):
	append_to_log(iuc.unit_name + " killed")
	if units.has(iuc.unit_name):
		units.erase(iuc.unit_name)
		if selected_unit == e:
			selected_unit = null
		# todo - hide button?

