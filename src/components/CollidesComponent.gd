class_name CollidesComponent # todo - rename to Collider
extends Area2D

# This is not a proper component!  Todo - delete this

export var blocks : bool

func _on_CollidesComponent_body_entered(body):
	var collision_system : CollisionSystem = get_tree().get_root().get_node("Main/Systems/CollisionSystem")
	collision_system.collision(body, self, blocks)
