extends Object
class_name Skill

var info
var unit

var cur_lv

func on_create(_unit,_info):
    unit=_unit
    info=_info

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

