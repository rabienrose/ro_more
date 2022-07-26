extends Routine

class_name Wander

var walk_to_routine
var idle_routine
var sequence_routine

func act():
    if state!=RUNNING:
        return
    if sequence_routine.state!=RUNNING:
        var temp_pos=unit.map.get_rand_free_cell_in_area(unit.cur_pos,10).pos
        walk_to_routine.set_tar_pos(temp_pos)
        idle_routine.reset()
        idle_routine.set_duration(Global.rng.randi_range(0,1000))
        sequence_routine.reset()
        sequence_routine.state=RUNNING
    sequence_routine.act()
    
func on_create(_unit):
    .on_create(_unit)
    walk_to_routine=WalkTo.new()
    walk_to_routine.on_create(_unit)
    idle_routine=Idle.new()
    idle_routine.on_create(_unit)
    sequence_routine=Sequence.new()
    sequence_routine.on_create(_unit)
    sequence_routine.routines=[idle_routine, walk_to_routine]

func stop_routine():
    .stop_routine()
    sequence_routine.stop_routine()

func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        sequence_routine.free()
