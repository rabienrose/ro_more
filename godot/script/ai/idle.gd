extends Routine

class_name Idle

var duration_t
var s_t

func reset(t):
    duration_t=t
    s_t=OS.get_ticks_msec()
    status=RUNNING

func act():
    if status!=RUNNING:
        return
    if OS.get_ticks_msec()-s_t<=duration_t:
        status=SUCC