extends Routine

class_name Selector

var routines=[]
var cur_routine=-1

func reset():
    .reset()
    cur_routine=0
    for r in routines:
        r.reset()

func act():
    while true:
        if status!=RUNNING:
            return
        if cur_routine>=routines.size():
            status=FAIL
            return
        routines[cur_routine].act()
        if routines[cur_routine].status==FAIL:
            cur_routine=cur_routine+1
        elif routines[cur_routine].status==SUCC:
            status=SUCC
            return
        else:
            return