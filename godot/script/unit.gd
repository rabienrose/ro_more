extends Node2D

class_name Unit

var map

var mov_spd=64
var frame_delta

var cur_pos

var brain

func set_cell_pos(pos_c):
    cur_pos=pos_c
    position=map.pos_2_pixel(pos_c)

func set_pixel_pos(pos_p):
    position=pos_p
    cur_pos=map.pixel_p_cell(pos_p)

func on_create(_map):
    map=_map

func _ready():
    brain=Wander.new()
    brain.on_create(self)
    brain.status=Routine.RUNNING

func _process(delta):
    frame_delta=delta
    brain.act()
