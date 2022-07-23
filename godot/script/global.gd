extends Node

var map_data_path="res://binary/images/map/"
var mob_res_path="res://objects/mobs/"
var buf_script_path="res://script/buf/"
var player_path="res://objects/player.tscn"

var pixel_p_cell=32

var rng
var inc_unit_id=-1

enum {MOB,PLAYER}

func check_near_enough(v1, v2, dist_cell):
    var diff_v = v1-v2
    if abs(diff_v.x)<dist_cell+0.1 and abs(diff_v.y)<dist_cell+0.1:
        return true
    else:
        return false

func get_new_unit_id():
    inc_unit_id=inc_unit_id+1
    return inc_unit_id

func _ready():
    rng=RandomNumberGenerator.new()

func dir_2_vec(d_ind):
    if d_ind==0:
        return Vector2(0,-1)
    elif d_ind==1:
        return Vector2(1,-1)
    elif d_ind==2:
        return Vector2(1,0)
    elif d_ind==3:
        return Vector2(1,1)
    elif d_ind==4:
        return Vector2(0,1)
    elif d_ind==5:
        return Vector2(-1,1)
    elif d_ind==6:
        return Vector2(-1,0)
    elif d_ind==7:
        return Vector2(-1,-1)

func get_buf_obj(buf_name):
    var script_path = buf_script_path+"buf_"+buf_name+".gd"
    var res=load(script_path)
    if res!=null:
        return res.new()
    else:
        print("buf script not exist!!")
        return null
