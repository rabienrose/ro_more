extends Routine

var follow_attck_routine
var wander_routine
var enemy=null
var mode="wander"

func act():
    if state!=RUNNING:
        return
    if mode=="attack":
        if follow_attck_routine.state==RUNNING:
            follow_attck_routine.act()
        else:
            mode="wonder"
            wander_routine.reset_run()
            enemy=null
    elif mode=="wander":
        if enemy!=null:
            mode="attack"
            follow_attck_routine.set_tar(enemy)
            follow_attck_routine.reset_run()
        else:
            wander_routine.act()

func on_owner_hitted(new_enemy):
    if new_enemy!=enemy:
        enemy=new_enemy
        follow_attck_routine.set_tar(enemy)
        follow_attck_routine.reset_run()

func on_create(_unit):
    .on_create(_unit)
    unit.connect("on_hitted",self, "on_owner_hitted")
    follow_attck_routine=Global.get_ai_obj("follow_attack", unit)
    wander_routine=Global.get_ai_obj("wander", unit)
    wander_routine.reset_run()

func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        follow_attck_routine.free()
        follow_attck_routine=null
        wander_routine.free()
        wander_routine=null
    
        
    
    
