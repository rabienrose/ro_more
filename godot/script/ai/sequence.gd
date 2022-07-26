extends Routine

class_name Sequence

var routines=[]
var cur_routine=-1

func reset():
    .reset()
    cur_routine=-1
    for r in routines:
        r.reset()

func act():
    if state!=RUNNING:
        return
    while true:
        if cur_routine==-1:
            cur_routine=0
            routines[cur_routine].state=RUNNING
        routines[cur_routine].act()
        if routines[cur_routine].state==SUCC:
            cur_routine=cur_routine+1
            if cur_routine>=routines.size():
                state=SUCC
                break
            routines[cur_routine].state=RUNNING
        elif routines[cur_routine].state==FAIL:
            state=FAIL
            break
        else:
            break

func stop_routine():
    .stop_routine()
    if cur_routine!=-1:
        routines[cur_routine].stop_routine()

func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        for r in routines:
            r.free()
        routines=[]
