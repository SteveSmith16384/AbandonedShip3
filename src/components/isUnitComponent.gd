class_name IsUnitComponent
extends Component

# Is a unit, may be players or an enemy.  Can shoot and be shot at.

export var unit_name : String
export var side : int
export var health : float = 100
var is_players : bool
var unit_selector_button
var current_item : Entity
var carrying = [] # entities list
var to_pickup

# Shooting
var current_target
var next_shot_time : float
var is_alive : bool = true

var damage_this_loop : float
