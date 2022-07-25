extends Camera2D

export (NodePath) var map_path

var map

var smooth_rate=0.95
var target_pos=null

# var last_pos=Vector2(0,0)

func _ready():
    map=get_node(map_path)

func set_delay(pos_p):
    position=position+pos_p
        
func _process(_delta):
    if abs(position.x)>1 or abs(position.y)>1:
        position=position*smooth_rate
        
