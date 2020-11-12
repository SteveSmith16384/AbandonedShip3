extends Node

var selected_unit : Entity
#var units[]
var screen_size

func _ready():
	create_units()
	screen_size = get_viewport().size
	
func create_units():
	var start_pos = get_node("StartLocation")
	

	var unit = load("res://entities/UnitEntity.tscn")
	
	var syylk = unit.instance()
	add_child(syylk)
	syylk.position = start_pos.position
	var syylk_img = preload("res://assets/sprites/syylk.png")
	syylk.get_node("Sprite").set_texture(syylk_img)
	
	var sevrina = unit.instance()
	add_child(sevrina)
	sevrina.position = start_pos.position
	var sevrina_img = preload("res://assets/sprites/sevrina.png")
	sevrina.get_node("Sprite").set_texture(sevrina_img)
	
	selected_unit = syylk
	pass
	
	
func _process(delta):
	ECS.update()
	
	if selected_unit:
		$Camera2D.position = selected_unit.position

	pass
	
	
func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
		if event.button_index == 1:
			var e = getEntityAtPosition(event.position)
			if e:
				selected_unit = e
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
	
