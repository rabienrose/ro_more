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
        if state!=RUNNING:
            return
        if cur_routine>=routines.size():
            state=FAIL
            return
        routines[cur_routine].act()
        if routines[cur_routine].state==FAIL:
            cur_routine=cur_routine+1
        elif routines[cur_routine].state==SUCC:
            state=SUCC
            return
        else:
            return

func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        for r in routines:
            r.free()
        routines=[]