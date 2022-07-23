extends Mob

func get_brain():
    var routine=FollowAttack.new()
    routine.on_create(self)
    return routine

func set_tar(target):
    brain.set_tar(target)

func _ready():
    mov_spd=100
