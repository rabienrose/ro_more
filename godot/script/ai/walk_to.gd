extends Routine

class_name WalkTo

var tar_pos
var path=[]
var cur_path_ind=-1

var mov_routine

func set_tar_pos(_tar_pos):
    tar_pos=_tar_pos
    cur_path_ind=-1
    path = unit.map.cal_path(unit.cur_pos, _tar_pos)
    if path.size()==0:
        status=FAIL
    else:
        status=RUNNING

func act():
    if status!=RUNNING:
        return 
    if path.size()==0:
        status=FAIL
        return
    if mov_routine.status==RUNNING:
        mov_routine.act()
        return
    else:
        cur_path_ind=cur_path_ind+1
        if cur_path_ind>=path.size():
            status=SUCC
            return
        else:
            mov_routine.set_tar_pos(path[cur_path_ind])
            mov_routine.status=RUNNING
    
func on_create(_unit):
    .on_create(_unit)
    mov_routine=Move.new()
    mov_routine.on_create(_unit)
