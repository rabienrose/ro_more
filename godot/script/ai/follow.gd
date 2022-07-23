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
    if status!=RUNNING:
        return
    if mov_routine.status==SUCC:
        if (target.cur_pos-unit.cur_pos).length()<1.0:
            status=SUCC
            return
        else:
            var path = unit.map.cal_path(unit.cur_pos,target.cur_pos)
            if path.size()==0:
                status=FAIL
                return
            elif path.size()==1:
                status=SUCC
                return
            else:
                mov_routine.set_tar_pos(path[1])
                mov_routine.status=RUNNING
    elif mov_routine.status==RUNNING:
        mov_routine.act()
    else:
        status=FAIL
        

func on_create(_unit):
    .on_create(_unit)
    mov_routine=Move.new()
    mov_routine.on_create(_unit)
        
    
    
