extends Routine

class_name WalkTo

var tar_pos
var path=[]
var cur_path_ind=0

var mov_routine

func stop_routine():
    .stop_routine()
    mov_routine.stop_routine()

func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        mov_routine.free()
        mov_routine=null

func reset():
    .reset()
    cur_path_ind=0

func set_tar_pos(_tar_pos):
    tar_pos=_tar_pos
    cur_path_ind=0
    path = unit.map.cal_path(unit.cur_pos, _tar_pos, 20)
    if path.size()==0:
        state=FAIL
    else:
        state=RUNNING

func act():
    if state!=RUNNING:
        return 
    if path.size()==0:
        state=FAIL
        return
    if mov_routine.state==RUNNING:
        mov_routine.act()
    else:
        cur_path_ind=cur_path_ind+1
        if cur_path_ind>=path.size():
            state=SUCC
        else:
            mov_routine.set_tar_pos(path[cur_path_ind])
            mov_routine.state=RUNNING
    
func on_create(_unit):
    .on_create(_unit)
    mov_routine=Move.new()
    mov_routine.on_create(_unit)
