extends Routine

class_name Attack

var target
var s_time=0
var pre_time=0.2
var attcked=false

func reset():
    .reset()
    s_time=OS.get_ticks_msec()
    attcked=false

func set_tar(_tar):
    target=_tar

func act():
    if state!=RUNNING:
        return
    if !is_instance_valid(target) or target.b_dead==true:
        state=FAIL
        return
    if not Global.check_near_enough(target.cur_pos, unit.cur_pos, unit.atk_range):
        state=FAIL
    else:
        if OS.get_ticks_msec()-s_time<unit.atk_spd*1000*pre_time:
            pass
        else:
            if attcked==false:
                unit.do_attack(target, false)
                attcked=true
            if OS.get_ticks_msec()-s_time>unit.atk_spd*1000:
                state=SUCC
    
    
