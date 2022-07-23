extends Node2D

class_name Unit

var map
var frame_delta
var cur_pos
var brain

var mov_spd=64
var atk=5
var hp=20
var atk_range=3
var atk_spd=1

export (NodePath) var hp_bar_path
export (NodePath) var atk_bar_path

func attack(target):
    target.hp=target.hp-atk
    target.update_board()

func update_board():
    get_node(hp_bar_path).text="hp:"+str(hp)
    get_node(atk_bar_path).text="atk:"+str(atk)

func get_brain():
    print("unit cannot run there!!")

func set_cell_pos(pos_c):
    cur_pos=pos_c
    position=map.pos_2_pixel(pos_c)

func set_pixel_pos(pos_p):
    position=pos_p
    cur_pos=map.pixel_p_cell(pos_p)

func on_create(_map):
    map=_map

func _ready():
    brain=get_brain()
    brain.status=Routine.RUNNING
    update_board()

func _process(delta):
    frame_delta=delta
    brain.act()
