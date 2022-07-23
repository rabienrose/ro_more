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
    if status!=RUNNING:
        return
    while true:
        if cur_routine==-1:
            cur_routine=0
            routines[cur_routine].status=RUNNING
        routines[cur_routine].act()
        if routines[cur_routine].status==SUCC:
            cur_routine=cur_routine+1
            if cur_routine>=routines.size():
                status=SUCC
                break
            routines[cur_routine].status=RUNNING
        elif routines[cur_routine].status==FAIL:
            status=FAIL
            break
        else:
            break
