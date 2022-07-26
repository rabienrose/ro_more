extends Item
class_name Equip

enum {MELEE, RANGE}

var q_damage=0
var q_def=0
var q_type
var q_name
var atk_type
var slot_count
var slots=[]
var refine_lv=0
var bufs=[]

func on_use():
    pass

func on_take_on():
    pass

func on_take_off():
    pass