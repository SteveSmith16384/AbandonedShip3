extends Node2D

export (PackedScene) var Playerxx

var players = []
var selected_avatar = null

export (NodePath) var patrol_path
var patrol_points
var patrol_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if $Path2D:
		patrol_path = $Path2D
		patrol_points = $Path2D.curve.get_baked_points()
		
	var player = Playerxx.instance()
	player.position.x = 100
	add_child(player)
	players.push_back(player)
	var res = player.connect("clicked", self, "handleclicked")
	
	var player2 = Playerxx.instance()
	player2.position.x = 200
	add_child(player2)
	players.push_back(player2)
	res = player2.connect("clicked", self, "handleclicked")
	
	#emit_signal("test")

	#var pe = players[0] #get_tree().get_root().find_node("Playerxx",true,true)
	#pe.connect("clicked2",self,"handleplayerspotted") WORKS
	#pe.connect("clicked2", pe, "handleplayerspotted") DOESNT WORK
	#pe.connect("clicked", self, "handleclicked")
	pass


func handleplayerspotted(): #message, whoistheplayer):
	#print("Enemy has spotted me")
	pass


func handleclicked(whoistheplayer): #message, whoistheplayer):
	#print("Enemy has spotted me")
	selected_avatar = whoistheplayer
	#selected_avatar.add_child($Camera)

	
func _physics_process(delta):
	var space_rid = get_world_2d().space
	var space_state = Physics2DServer.space_get_direct_state(space_rid)
	#$Camera.po
	# todo - do for each avatar
	#var result = space_state.intersect_ray($Player.position, $Enemy_Node2D.position, [$Player])
	#var idx = $Enemy_Node2D.get_child(0)
	#if (result.collider == idx):
	#	print("Can see")
	
	if !patrol_path:
		return
	var target = patrol_points[patrol_index]
	var pos = $Enemy_Node2D.position
	var dist = pos.distance_to(target)
	#print(dist)
	if dist < 10:
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
		target = patrol_points[patrol_index]
	var velocity = (target - $Enemy_Node2D.position).normalized() * 100
	velocity = $Enemy_Node2D.move_and_slide(velocity)

	if selected_avatar:
		$Camera2D.position = selected_avatar.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event):
	#func _on_Player_input_event(viewport, event, shape_idx):
	#print("hello")
	if event.is_action_pressed('rightclick'):
		#if ($Player/CollisionShape2D.coll
		if (is_instance_valid(selected_avatar)):
			selected_avatar.target = get_global_mouse_position()
			print("Destination selected")



#func _on_Player_clicked(entity):
#	print("Avatar selected")
#	if (is_instance_valid(selected_avatar)):
#		selected_avatar.remove_child(0)
#	selected_avatar = entity
#	selected_avatar.add_child($Camera)
#	pass


func _on_Node2D_test():
	pass # Replace with function body.
