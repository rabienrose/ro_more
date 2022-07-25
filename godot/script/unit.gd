extends Node2D

class_name Unit

export (NodePath) var hp_bar_path
export (NodePath) var sp_bar_path

enum {
        EQI_ACC_L ,
        EQI_ACC_R,
        EQI_SHOES,
        EQI_GARMENT,
        EQI_HEAD_LOW,
        EQI_HEAD_MID,
        EQI_HEAD_TOP,
        EQI_ARMOR,
        EQI_HAND_L,
        EQI_HAND_R,
        EQI_AMMO,
        EQI_MAX
    }

var map
var frame_delta
var cur_pos=null

var b_dead=false

var last_pos=null
var uid=-1
var u_type

var mov_spd=64
var atk=5
var hp=20
var atk_range=1
var atk_spd=1
var sp
var max_hp
var max_sp
var str_
var agi_
var vit_
var int_
var dex_
var luk_
var hit
var flee
var cri
var matk_min
var matk_max
var speed
var aspd_rate
var def
var mdef
var bexp
var jobexp
var blv
var joblv
var job

var equips=[]

var skills={}
var bufs={}


func get_str():
    return str_

func get_dex():
    return dex_

func proc_skill_flee(ori_flee):
    for skill in skills:
        ori_flee=skill.proc_skill_flee(ori_flee)
    return ori_flee

func proc_buf_flee(ori_flee):
    for buf in bufs:
        ori_flee=buf.proc_buf_flee(ori_flee)
    return ori_flee

func attack(target):
    var b_hit = StatusCal.check_hit(self,target,1)
    if b_hit:
        var damage = 0
        if equips[EQI_HAND_R]==null or equips[EQI_HAND_R]!=null and equips[EQI_HAND_R].atk_type==Equip.MELEE:
            damage=StatusCal.cal_melee_damage(self,target)
        elif equips[EQI_HAND_R]!=null and equips[EQI_HAND_R].atk_type==Equip.RANGE:
            damage=StatusCal.cal_range_damage(self,target)
        print("damage: ",damage)
        var die = target.damage(damage)
        if die:
            on_target_die(target)
    else:
        print("miss")

func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        for buf in bufs:
            bufs[buf].free()
        bufs={}

func on_target_die(target):
    pass

func damage(dmg_amount):
    hp=hp-dmg_amount
    if hp<=0:
        b_dead=true
        map.remove_unit(self)
        return true
    update_board()
    return false

func update_board():
    get_node(hp_bar_path).text="hp:"+str(hp)+"/"+str(max_hp)
    get_node(sp_bar_path).text="sp:"+str(sp)+"/"+str(max_sp)

func set_cell_pos(pos_c):
    map.on_unit_cell_change(self, cur_pos, pos_c)
    cur_pos=pos_c
    position=map.pos_2_pixel(pos_c)

func on_create(_map):
    map=_map

func _ready():

    uid=Global.get_new_unit_id()
    update_board()

func add_buf(buf_name):
    var buf_obj = Global.get_buf_obj(buf_name)
    if buf_obj!=null:
        buf_obj.on_create(self)
        buf_obj.start()
        bufs[buf_name]=buf_obj

func _process(delta):
    frame_delta=delta
    for buf_name in bufs:
        var buf=bufs[buf_name]
        buf.update()
        if buf.state==Buf.END:
            buf.free()
            bufs.erase(buf_name)
