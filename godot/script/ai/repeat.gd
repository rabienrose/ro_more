extends Routine

class_name Repeat

var routine

func reset():
    .reset()
    routine.reset()

func act():
    if status!=RUNNING:
        return
    if routine.status==SUCC:
        routine.reset()
        routine.status=RUNNING
    elif routine.status==FAIL:
        status=FAIL
    else:
        routine.act()

        
    
    
