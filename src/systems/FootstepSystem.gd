extends Node


var main

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_tree().get_root().get_node("Main")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if main.selected_unit:
		var d : DestinationComponent = ECS.entity_get_component(main.selected_unit, "DestinationComponent")
		var player = get_node("AudioStreamPlayer")
		if d.has_destination:
			if player.playing == false:
				player.play()
		else:
			player.stop()
	pass
