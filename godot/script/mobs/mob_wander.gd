extends Mob

func get_brain():
    var wander_routine=Wander.new()
    wander_routine.on_create(self)
    return wander_routine

func _ready():
    pass
