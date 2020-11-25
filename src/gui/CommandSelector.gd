extends CanvasLayer


func _on_Move_pressed():
	var main = getMain()
	main.set_command(Globals.CMD_MOVE)
	pass


func getMain():
	var main = get_tree().get_root().get_node("Main")
	return main


func _on_Pickup_pressed():
	var main = getMain()
	main.set_command(Globals.CMD_PICKUP)
	pass # Replace with function body.


func _on_Use_pressed():
	var main = getMain()
	main.set_command(Globals.CMD_USE)
	pass # Replace with function body.


func _on_Drop_pressed():
	var main = getMain()
	main.set_command(Globals.CMD_DROP)
	pass # Replace with function body.
