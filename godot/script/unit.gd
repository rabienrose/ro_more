extends Node2D

class_name Unit

var map

var mov_spd=64
var frame_delta

var cur_pos

var brain

func on_create(_map):
    map=_map

func _ready():
    brain=Wander.new()
    brain.on_create(self)

func _process(delta):
    brain.act()
