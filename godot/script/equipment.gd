extends Item
class_name Equipment

var q_atk=0
var q_matk=0
var q_def=0
var q_mdef=0
var q_position
var q_name
var atk_type
var slot_count
var slots=[]
var refine_lv=0
var atk_range=1

func get_q_atk():
    return q_atk

func get_q_def():
    return q_def

func get_q_matk():
    return q_matk

func get_q_mdef():
    return q_mdef

func on_use():
    pass

func on_take_on():
    pass

func on_take_off():
    pass