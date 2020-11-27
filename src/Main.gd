extends Node

var selected_unit : Entity
var units = {}
var screen_size : Vector2
var entity_factory
var current_command : int

func _ready():
	var ef = load("res://EntityFactory.tscn")
	entity_factory = ef.instance()

	create_player_units()
	create_enemy_units()
	screen_size = get_viewport().size
	append_to_log("Ready!")
	
	
func create_player_units():
	var start_pos = null
	for child in get_node("StartPositions").get_children():
		if child is Node2D:
			if child.type == 0:
				start_pos = child.position
				break
#	var start_pos = get_node("StartLocation")
	
	var syylk = create_player_unit("zark", start_pos)
	create_player_unit("syylk", start_pos)
	create_player_unit("sevrina", start_pos)
	create_player_unit("torik", start_pos)
	create_player_unit("manto", start_pos)
	create_player_unit("maul", start_pos)
	
	selected_unit = syylk
	pass
	

func create_player_unit(name, start_pos : Vector2):
	var syylk_img = load("res://assets/sprites/" + name + ".png")
	var syylk = entity_factory.create_player_unit(self, name, start_pos)

	#  Add button icon
	var b = load("res://gui/UnitSelectorButton.tscn")
	var usb = b.instance()
	usb.unit = syylk
	var button = usb.find_node("Button")
	button.text = name
	button.icon = syylk_img
	var node = get_node("HUD/UnitSelector/MarginContainer/UnitButtonContainer")
	node.add_child(usb)

	var iuc = ECS.entity_get_component(syylk, "isunitcomponent")
	iuc.unit_selector_button = usb
	
	set_unit_health(syylk, iuc.health)
	
	units[name] = syylk
	
	return syylk
	
	
func create_enemy_units():
	for child in get_node("StartPositions").get_children():
		if child is Node2D:
			if child.type == 1: # enemy position
				var start_pos = child.position
				var name = "kryxix" # todo
				#var syylk_img = load("res://assets/sprites/" + name + ".png")
				entity_factory.create_enemy_unit(self, name, start_pos)
	pass
	

func _process(delta):
	ECS.update()
	
	if selected_unit:
		$Camera2D.position = selected_unit.position

	pass
	
	
func _unhandled_input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton && event.pressed:
		#print("Mouse Click/Unclick at: " , event.pressed)
		if event.button_index == 1:
			var e = getEntityAtPosition(event.position)
			if e:
				if ECS.entity_has_component(e, "isunitcomponent"):
					select_unit_by_entity(e)
				elif ECS.entity_has_component(e, "isequipmentcomponent"):
					set_destination(event.position)
					unit_pickup_entity(e)
			else:
				append_to_log("Nothing there")
		elif event.button_index == 2 and selected_unit:
			set_destination(event.position)
	pass
	

func getEntityAtPosition(position : Vector2):
	var system = ECS.systems.get("selectunitsystem")
	var entities = ECS.system_entities["selectunitsystem"]
	var pos = Vector2(position)
	pos.x += $Camera2D.position.x - screen_size.x/2
	pos.y += $Camera2D.position.y - screen_size.y/2
	var e = system.get_entity_at(entities, pos)
	return e



func set_destination(position : Vector2):
	var pos = Vector2(position)
	pos.x += $Camera2D.position.x - screen_size.x/2
	pos.y += $Camera2D.position.y - screen_size.y/2
	var c = ECS.entity_get_component(selected_unit, "destinationcomponent")
	c.destination = pos
	c.has_destination = true
	
	# Do voice
	if ECS.entity_has_component(selected_unit, "hasvoicecomponent"):
		var hv = ECS.entity_get_component(selected_unit, "hasvoicecomponent")
		hv.to_play = Globals.SPEECH_OK
	append_to_log("Destination selected")


func unit_pickup_entity(entity : Entity):
	var scbs = ECS.entity_get_component(selected_unit, "isunitcomponent")
	scbs.to_pickup = entity
	append_to_log("Unit will pick up " + entity.name)
	pass
	
	
func select_unit_by_name(name : String):
	select_unit_by_entity(units[name])
	
	
func select_unit_by_entity(e):
	selected_unit = e
	if e != null:
		if ECS.entity_has_component(selected_unit, "hasvoicecomponent"):
			var hvc = ECS.entity_get_component(selected_unit, "hasvoicecomponent")
			hvc.to_play = Globals.SPEECH_READY
		var scbs = ECS.entity_get_component(e, "isunitcomponent")
		append_to_log(scbs.unit_name + " selected")
	pass


func append_to_log(text : String):
	print("Appending: " + text)
	var l = get_node("HUD/GameLog")
	l.append(text)
	pass


func set_unit_health(entity, health):
	var iuc = ECS.entity_get_component(entity, "isunitcomponent")
	var usb = iuc.unit_selector_button
	if usb:
		var bar = usb.find_node("HealthBar")
		bar.value = health
	pass
	
	
func entity_killed(e, iuc):
	if units.has(iuc.unit_name):
		units.erase(iuc.unit_name)
		if selected_unit == e:
			selected_unit = null
		# todo - hide button?
	pass
	

func play_sfx(file : String):
	var sfx = load("res://assets/sfx/" + file)
	$AudioStreamPlayer2D.stream = sfx
	$AudioStreamPlayer2D.play()
	pass
	

func set_command(cmd : int):
	current_command = cmd
	pass
	
