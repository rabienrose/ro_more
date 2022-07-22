extends Node

var map_data_path="res://binary/images/map/"
var mob_res_path="res://objects/mobs/"

var pixel_p_cell=32

var rng

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
