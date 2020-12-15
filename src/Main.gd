class_name Main
extends Node

var selected_unit : Entity
var units = {}
var screen_size : Vector2
var entity_factory
var current_command : int
var rnd = RandomNumberGenerator.new()

func _ready():
	rnd.randomize()
	var ef = load("res://EntityFactory.tscn")
	entity_factory = ef.instance()

	create_player_units()
	create_enemy_units()
	create_equipment()
	screen_size = get_viewport().size
	append_to_log("Ready!")
	
	
func create_player_units():
	var syylk = create_player_unit("hazel", getStartPosition())
	create_player_unit("sam", getStartPosition())
	create_player_unit("tom", getStartPosition())
	selected_unit = syylk
	pass
	
	
func getStartPosition():
	var sz = get_node("Entities/MapEntity/StartPositions").get_children().size()
	var id = rnd.randi_range(0, sz-1)
	var pos = get_node("Entities/MapEntity/StartPositions").get_child(id)
	get_node("Entities/MapEntity/StartPositions").remove_child(pos)
	return pos.position

	
func create_player_unit(name, start_pos : Vector2):
	var syylk = entity_factory.create_player_unit(self, name, start_pos)

	#  Add button icon
	var syylk_img = load("res://assets/sprites/zark.png")
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
	var name = "alien" # todo
	entity_factory.create_enemy_unit(self, name, getStartPosition())
	entity_factory.create_enemy_unit(self, name, getStartPosition())
	pass
	

func create_equipment():
	entity_factory.create_gun(self, getStartPosition())
	entity_factory.create_gun(self, getStartPosition())
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
		hv.to_play.push_back(Globals.SPEECH_ON_MY_WAY)
	append_to_log("Destination selected")


func unit_pickup_entity(entity : Entity):
	var scbs = ECS.entity_get_component(selected_unit, "isunitcomponent")
	scbs.to_pickup = entity
	var iseq : IsEquipmentComponent = ECS.entity_get_component(entity, "IsEquipmentComponent")
	append_to_log("Unit will pick up " + iseq.eq_name)
	pass
	
	
func select_unit_by_name(name : String):
	select_unit_by_entity(units[name])
	
	
func select_unit_by_entity(e : Entity):
	stop_playing() # Mainly to stop playing static
	selected_unit = e
	if e != null:
		if ECS.entity_has_component(selected_unit, "hasvoicecomponent"):
			var hvc : HasVoiceComponent = ECS.entity_get_component(selected_unit, "hasvoicecomponent")
			hvc.to_play.push_back(Globals.SPEECH_READY)
		var scbs = ECS.entity_get_component(e, "isunitcomponent")
		append_to_log(scbs.unit_name + " selected")
	else:
		# Play static
		play_sfx("white noise.wav")
	pass


func append_to_log(text : String):
	print("Appending: " + text)
	var l = get_node("HUD/GameLog")
	l.append(text)
	pass


func set_unit_health(entity : Entity, health : int):
	var iuc = ECS.entity_get_component(entity, "isunitcomponent")
	var usb = iuc.unit_selector_button
	if usb:
		var bar = usb.find_node("HealthBar")
		bar.value = health
	pass
	
	
func entity_killed(e : Entity, iuc : IsUnitComponent):
	if e == selected_unit:
		selected_unit = null
		# Play static
		play_sfx("white noise.wav")
	if units.has(iuc.unit_name):
		units.erase(iuc.unit_name)
	#iuc.unit_selector_button.visible = false
	pass
	

func play_sfx(file : String):
	print("Playing " + file)
	var sfx = load("res://assets/sfx/" + file)
	$AudioStreamPlayer.stream = sfx
	$AudioStreamPlayer.play()
	pass
	

func stop_playing():
	$AudioStreamPlayer.stop()
	pass
	
	
func set_command(cmd : int):
	current_command = cmd
	pass
	

func unit_harmed(unit : Entity):
	var iuc : IsUnitComponent = ECS.entity_get_component(unit, "IsUnitComponent")
	#entity_killed(unit, iuc)
	iuc.damage_this_loop = 100 #todo
	pass
	
