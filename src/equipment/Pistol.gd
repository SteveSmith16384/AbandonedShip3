class_name Pistol
extends Entity


func _ready():
	var c2 = find_node("Components/IsEquipmentComponent")
	var c = find_node("IsEquipmentComponent")
	c.can_shoot = true
	c.shot_power = 1

