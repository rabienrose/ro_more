extends Routine

class_name Follow

var mov_routine
var target

func set_tar(_tar):
    target=_tar

func reset():
    .reset()
    mov_routine.reset()

func act():
    if state!=RUNNING:
        return
    if !is_instance_valid(target) or target.b_dead==true:
        state=FAIL
        return
    if mov_routine.state==SUCC:
        if Global.check_near_enough(target.cur_pos, unit.cur_pos,1):
            state=SUCC
            return
        else:
            var path = unit.map.cal_path(unit.cur_pos,target.cur_pos, 20)
            if path.size()==0:
                state=FAIL
                return
            elif path.size()==1:
                state=SUCC
                return
            else:
                mov_routine.set_tar_pos(path[1])
                mov_routine.state=RUNNING
    elif mov_routine.state==RUNNING:
        mov_routine.act()
    else:
        state=FAIL
        

func on_create(_unit):
    .on_create(_unit)
    mov_routine=Move.new()
    mov_routine.on_create(_unit)

func stop_routine():
    .stop_routine()
    mov_routine.stop_routine()

func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        mov_routine.free()
        mov_routine=null
    
    
    
