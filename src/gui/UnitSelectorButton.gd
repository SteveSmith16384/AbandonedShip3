class_name UnitSelectorButton
extends VBoxContainer

var unit


func _on_Button_pressed():
	var main = getMain()
	main.select_unit_by_entity(unit)
	pass


func getMain():
	var main = get_tree().get_root().get_node("Main")
	#var main = load("res://Main.gd")
	return main

