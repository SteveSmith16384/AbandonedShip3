extends System

var main : Main
var play : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_tree().get_root().get_node("Main")
	pass


func on_start_processing_entities():
	play = false
	pass
	
	
func on_process_entity(entity, delta: float):
	var sprite = entity.get_node("Sprite")
	play = sprite.visible or play
	pass


func on_finished_processing_entities():
	var player = get_node("AudioStreamPlayer")
	if play:
		if player.playing == false:
			player.play()
	else:
		player.stop()
	
	pass
	
