extends Routine

class_name FollowAttack

var follow_routine
var atk_routine
var repeat_routine1
var target

func set_tar(_tar):
    follow_routine.set_tar(_tar)
    atk_routine.set_tar(_tar)
    target=_tar

func act():
    if state!=RUNNING:
        return
    if !is_instance_valid(target) or target.b_dead==true:
        state=SUCC
        return
    if repeat_routine1.state!=RUNNING:
        if follow_routine.state==FAIL:
            state=FAIL
        else:
            repeat_routine1.reset()
            repeat_routine1.state=RUNNING
    repeat_routine1.act()

func on_create(_unit):
    .on_create(_unit)
    follow_routine=Follow.new()
    follow_routine.on_create(_unit)
    atk_routine=Attack.new()
    atk_routine.on_create(_unit)
    var repeat_atk_routine=Repeat.new()
    repeat_atk_routine.on_create(_unit)
    repeat_atk_routine.routine=atk_routine
    var seq_routine=Sequence.new()
    seq_routine.on_create(_unit)
    seq_routine.routines=[follow_routine, repeat_atk_routine]
    repeat_routine1=Repeat.new()
    repeat_routine1.on_create(_unit)
    repeat_routine1.routine=seq_routine

func stop_routine():
    .stop_routine()
    repeat_routine1.stop_routine()

func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        repeat_routine1.free()
        repeat_routine1=null
    
        
    
    
