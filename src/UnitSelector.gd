extends CanvasLayer



func _on_SelectZark_pressed():
	getMain().select_unit("zark")
	pass


func _on_SelectSyylk_pressed():
	getMain().select_unit("syylk")
	pass


func _on_SelectSevrina_pressed():
	getMain().select_unit("sevrina")
	pass


func _on_SelectTorik_pressed():
	getMain().select_unit("torik")
	pass


func _on_SelectManto_pressed():
	getMain().select_unit("manto")
	pass


func _on_SelectMaul_pressed():
	getMain().select_unit("maul")
	pass

func getMain():
	var main = get_tree().get_root().get_node("Main")
	return main
	
