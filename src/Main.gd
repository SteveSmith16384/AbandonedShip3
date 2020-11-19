extends Node

var selected_unit : Entity
var units = {}
var screen_size
var entity_factory

func _ready():
	var ef = load("res://EntityFactory.tscn")
	entity_factory = ef.instance()

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
	var syylk_img = load("res://assets/sprites/" + name + ".png")
	var syylk = entity_factory.create_unit(self, name, start_pos.position)

	#  Add button icon
	var b = load("res://gui/UnitSelectorButton.tscn")
	var usb = b.instance()
	var button = usb.find_node("Button")
	usb.unit = syylk
	button.text = name
	button.icon = syylk_img
	var node = get_node("HUD/UnitSelector/MarginContainer/UnitButtonContainer")
	node.add_child(usb)
	
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
	
	
func _unhandled_input(event):
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
		hv.to_play = Globals.SPEECH_OK
		append_to_log("Destination selected")


func select_unit_by_name(name : String):
	select_unit_by_entity(units[name])
	
	
func select_unit_by_entity(e):
	selected_unit = e
	if e != null:
		if ECS.entity_has_component(selected_unit.id, "hasvoicecomponent"):
			var hvc = ECS.entity_get_component(selected_unit.id, "hasvoicecomponent")
			hvc.to_play = Globals.SPEECH_READY
		var scbs = ECS.entity_get_component(e.id, "isunitcomponent")
		append_to_log(scbs.unit_name + " selected")
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

