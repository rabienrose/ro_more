extends Routine

class_name Wander

var walk_to_routine
var idle_routine
var sequence_routine

func act():
    if status!=RUNNING:
        return
    if sequence_routine.status==SUCC:
        walk_to_routine.set_tar_pos(unit.map.get_rand_free_cell())
        idle_routine.reset(Global.rng.randf_range(0,1))
        sequence_routine.reset()
        sequence_routine.status=RUNNING
    sequence_routine.act()
    
func on_create(_unit):
    .on_create(_unit)
    walk_to_routine=WalkTo.new()
    walk_to_routine.on_create(_unit)
    idle_routine=Idle.new()
    idle_routine.on_create(_unit)
    sequence_routine=Sequence.new()
    sequence_routine.routines=[idle_routine, walk_to_routine]
