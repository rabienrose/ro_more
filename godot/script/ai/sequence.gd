extends Routine

class_name Sequence

var routines=[]
var cur_routine=-1

func reset():
    cur_routine=0

func act():
    if status!=RUNNING:
        return
    while true:
        if cur_routine>=routines.size():
            status=SUCC
            return
        routines[cur_routine].act()
        if routines[cur_routine].status==SUCC:
            cur_routine=cur_routine+1
        elif routines[cur_routine].status==FAIL:
            status=FAIL
            return
        else:
            return
