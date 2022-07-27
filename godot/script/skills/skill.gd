extends Object
class_name Skill

var unit

var cur_lv
var need_update=false
var target_type="none"
var max_lv=0
var skill_name=""
var sp_cost=0
var cast_time=0
var delay=0
var cooldown=0
var cast_range=0

func on_create(_unit,_info):
    unit=_unit
    target_type=_info["target_type"]
    max_lv=_info["max_lv"]
    skill_name=_info["skill_name"]
    if "sp_cost" in _info:
        sp_cost=_info["sp_cost"]
    if "cast_time" in _info:
        cast_time=_info["cast_time"]
    if "delay" in _info:
        delay=_info["delay"]
    if "range" in _info:
        cast_range=_info["range"]

func set_lv(lv):
    cur_lv=lv

func on_use_skill():
    return

func on_place_skill(pos_c):
    return

func on_target_skill(tar_unit):
    return

func on_attach():
    pass

func on_detach():
    pass

func on_update():
    pass

