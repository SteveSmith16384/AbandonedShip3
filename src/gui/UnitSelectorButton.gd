#class_name UnitSelectorButton
extends Button

var unit

#func _init(_unit):
#	unit = _unit
#	pass

func _on_UnitSelectorButton_pressed():
	var main = getMain()
	main.select_unit_by_entity(unit)
	pass


func getMain():
	var main = get_tree().get_root().get_node("Main")
	#var main = load("res://Main.gd")
	return main

