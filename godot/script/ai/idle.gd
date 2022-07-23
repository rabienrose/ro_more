extends Routine

class_name Idle

var duration_t
var s_t

func reset():
    .reset()
    s_t=OS.get_ticks_msec()

func set_duration(t):
    duration_t=t

func act():
    if state!=RUNNING:
        return
    if OS.get_ticks_msec()-s_t>duration_t:
        state=SUCC
