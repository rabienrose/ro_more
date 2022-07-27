extends Skill

var recover_delay=5000
var last_recover=0
var recover_type="hp"
var recover_amount=[]

func on_create(_unit,_info):
    .on_create(_unit,_info)
    cur_lv=4
    recover_amount=_info["heal_val"]

func on_attach():
    need_update=true

func on_detach():
    need_update=true

func on_update():
    var cur_time= OS.get_ticks_msec()
    if cur_time-last_recover>recover_delay:
        last_recover=cur_time
        unit.heal(recover_amount[cur_lv])