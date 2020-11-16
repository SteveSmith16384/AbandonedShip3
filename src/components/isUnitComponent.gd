extends Component

# Is a unit, may be players or an enemy.  Can shoot and be shot at.

export var side : int

var health : float = 100
var unit_name : String
var current_target
var next_shot_time : float
var is_alive : bool = true
