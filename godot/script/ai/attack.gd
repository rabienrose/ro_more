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
    if status!=RUNNING:
        return
    if (target.cur_pos-unit.cur_pos).length()>unit.atk_range/2.0:
        status=FAIL
        return
    if OS.get_ticks_msec()-s_time<unit.atk_spd*1000*pre_time:
        return
    else:
        if attcked==false:
            unit.attack(target)
            attcked=true
        if OS.get_ticks_msec()-s_time>unit.atk_spd*1000:
            status=SUCC
            return
    
    
