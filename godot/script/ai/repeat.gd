extends Routine

class_name Repeat

var routine

func reset():
    .reset()
    routine.reset()

func act():
    if state!=RUNNING:
        return
    if routine.state==SUCC:
        routine.reset()
        routine.state=RUNNING
    elif routine.state==FAIL:
        state=FAIL
    else:
        routine.act()

func stop_routine():
    .stop_routine()
    routine.stop_routine()

func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        routine.free()
        routine=null
        
    
    
