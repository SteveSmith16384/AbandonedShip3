extends Node

var selected_unit
#var units[]
var screen_size

func _ready():
	#selected_unit = $Entities/UnitEntity
	screen_size = get_viewport().size #get_viewport_rect().size
	
	
func _process(delta):
	ECS.update()
	
	if selected_unit:
		$Camera2D.position = selected_unit.position

#	if Input.is_mouse_button_pressed(0):
#		print("mouse0!")
#	elif Input.is_mouse_button_pressed(1):
#		print("mouse1!")
#		#selected_unit = getEntityAtPosition()
#	elif Input.is_mouse_button_pressed(2):
#		print("mouse2!")
#	elif Input.is_mouse_button_pressed(3):
#		print("mouse3!")

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
		selected_unit = getEntityAtPosition(event.position)
	#elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)


func getEntityAtPosition(position : Vector2):
	var system = ECS.systems.get("selectunitsystem")
	var entities = ECS.system_entities["selectunitsystem"]
	var pos = Vector2(position)
	pos.x += $Camera2D.position.x - screen_size.x/2
	pos.y += $Camera2D.position.y - screen_size.y/2
	var e = system.get_entity_at(entities, pos)
	return e
	pass
