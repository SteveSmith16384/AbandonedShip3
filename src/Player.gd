extends KinematicBody2D

signal clicked(entity)
signal clicked2
#signal hit

var screen_size  # Size of the game window.

export (int) var speed = 200

var target = Vector2()
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func _physics_process(delta):
	velocity = (target - position).normalized() * speed
	# rotation = velocity.angle()
	if (target - position).length() > 5:
		var new_velocity = move_and_slide(velocity)	
		if (new_velocity.x == 0):
			#todo move_and_slide(Vector2(1, 1))
			pass
		elif (new_velocity.y == 0):
			# todo move_and_slide(Vector2(1, 1))
			pass
	pass


func _on_Player_body_entered(body):
	#hide()  # Player disappears after being hit.
	emit_signal("hit")
	#$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	pass
	
	
func _on_Player_hit():
	pass # Replace with function body.



func _on_Player_input_event():
	pass # Replace with function body.


func _on_Player_KinematicBody2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('leftclick'):
		emit_signal("clicked", self)
		emit_signal("clicked2")
		#print("Selected")

