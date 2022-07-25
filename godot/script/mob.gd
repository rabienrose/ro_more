extends Unit

class_name Mob

var brain

var baseexp=0
var jobexp=0
var drop_list=[]
var skills=[]
var last_hit_target=null

func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        brain.free()

func init_with_info(info):
    mov_spd=info["mov_spd"]
    atk=info["atk"]
    max_hp=info["hp"]
    hp=max_hp
    max_sp = info["sp"]
    sp=max_sp
    atk_range=info["atk_range"]
    atk_spd=info["atk_spd"]
    hit=info["hit"]
    flee=info["flee"]
    cri=info["cri"]
    matk_min=info["matk_min"]
    matk_max=info["matk_max"]
    def=info["def"]
    mdef=info["mdef"]
    blv=info["lv"]
    baseexp=info["baseexp"]
    jobexp=info["jobexp"]
    brain = Global.get_ai_obj(info["ai"]["class"], self)
    brain.state=Routine.RUNNING
    drop_list=info["items"]
    skills=info["skills"]

func _ready():
    u_type=Global.MOB

func _process(delta):
    frame_delta=delta
    if brain.state==Routine.RUNNING:
        brain.act()
