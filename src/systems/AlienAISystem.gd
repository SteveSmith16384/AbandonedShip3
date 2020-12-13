extends System

var main
var space_state
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	main = get_tree().get_root().get_node("Main")
	var space_rid = main.get_world_2d().space
	space_state = Physics2DServer.space_get_direct_state(space_rid)
	pass
	

func on_process_entity(entity : Entity, delta: float):
	var dc = ECS.entity_get_component(entity, "DestinationComponent")
	if dc.has_destination:
		return
		
	var alien = ECS.entity_get_component(entity, "IsAlienComponent")
	# todo - only check every few seconds
	
	for unit in main.units.values():
		if check_if_visible(entity, unit):
			return
	pass


func check_if_visible(alien : Entity, player : Entity):
	var seen = check_can_see(alien, player, main, space_state)
	if seen:
		var dc : DestinationComponent = ECS.entity_get_component(alien, "DestinationComponent")
		dc.has_destination = true
		dc.destination = player.position
		
		var main = get_tree().get_root().get_node("Main")
		#main.play_sfx("aliennoise1.wav")
		var filename = "monster_sfx_pack_2/monster-" + str(rng.randi_range(1, 17)) + ".wav"
		main.play_sfx(filename)
		# Stop moving if an ememy?
#		if ECS.entity_has_component(enemy, "isunitcomponent"): # must be an enemy
#			# Voice
#			if ECS.entity_has_component(unit, "hasvoicecomponent"):
#				var hvc = ECS.entity_get_component(unit, "hasvoicecomponent")
#				hvc.to_play.push_back(Globals.SPEECH_SEEN_ENEMY)
	return seen

		
func check_can_see(us, enemy, main, space_state):
	var result = space_state.intersect_ray(enemy.position, us.position, [us])
	return result.size() == 0

