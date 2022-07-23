extends Object

class_name Routine

enum {RUNNING, FAIL, SUCC}

var state=SUCC
var unit

func reset():
    state=SUCC

func on_create(_unit):
    unit=_unit

func act():
    pass

func stop_routine():
    state=FAIL

func reset_run():
    reset()
    state=RUNNING
