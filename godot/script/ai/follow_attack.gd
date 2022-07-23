extends Routine

class_name FollowAttack

var follow_routine
var atk_routine
var repeat_routine1

func set_tar(_tar):
    follow_routine.set_tar(_tar)
    atk_routine.set_tar(_tar)

func act():
    if status!=RUNNING:
        return
    if repeat_routine1.status!=RUNNING:
        repeat_routine1.reset()
        repeat_routine1.status=RUNNING
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

    
        
    
    