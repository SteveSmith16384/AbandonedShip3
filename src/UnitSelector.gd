extends CanvasLayer



func _on_SelectZark_pressed():
	getMain().select_unit_by_name("zark")
	pass


func _on_SelectSyylk_pressed():
	getMain().select_unit_by_name("syylk")
	pass


func _on_SelectSevrina_pressed():
	getMain().select_unit_by_name("sevrina")
	pass


func _on_SelectTorik_pressed():
	getMain().select_unit_by_name("torik")
	pass


func _on_SelectManto_pressed():
	getMain().select_unit_by_name("manto")
	pass


func _on_SelectMaul_pressed():
	getMain().select_unit_by_name("maul")
	pass

func getMain():
	var main = get_tree().get_root().get_node("Main")
	return main
	
