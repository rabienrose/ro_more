extends Unit

class_name Mob

var brain

func get_brain():
    var routine =Routine.new()
    routine.on_create(self)
    return routine

func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        brain.free()

func _ready():
    u_type=Global.MOB
    brain=get_brain()
    brain.state=Routine.RUNNING

func _process(delta):
    frame_delta=delta
    if brain.state==Routine.RUNNING:
        brain.act()
