extends Mob

var follow_routine


func get_brain():
    follow_routine=Follow.new()
    follow_routine.on_create(self)
    var idle_routine=Idle.new()
    idle_routine.on_create(self)
    idle_routine.reset()
    idle_routine.set_duration(1000)
    var seq_routine=Sequence.new()
    seq_routine.on_create(self)
    seq_routine.routines=[follow_routine, idle_routine]
    var repeat_routine=Repeat.new()
    repeat_routine.on_create(self)
    repeat_routine.routine=seq_routine
    return repeat_routine


func set_tar(target):
    follow_routine.set_tar(target)

func _ready():
    pass
    
