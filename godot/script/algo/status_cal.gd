extends Object
class_name StatusCal

static func cal_matk_min(src_unit):
    return floor(src_unit.blv / 4 + src_unit.get_int()*1.5 + src_unit.get_dex() / 5 + src_unit.get_luk() / 3)

static func cal_matk_max(src_unit):
    return cal_matk_min(src_unit)

static func cal_atk_var(src_unit):
    var v=src_unit.get_luk()/100.0
    return v

static func cal_atk_min(src_unit):
    var raw_atk=cal_static_atk(src_unit)
    var atk_var=cal_atk_var(src_unit)
    return int(raw_atk*(1-atk_var+src_unit.get_dex()/100))

static func cal_atk_max(src_unit):
    var raw_atk=cal_static_atk(src_unit)
    var atk_var=cal_atk_var(src_unit)
    return int(raw_atk*(1+atk_var))

static func cal_atk_range(src_unit):
    return 1

static func cal_mdef_mul(src_unit):
    var total_def=0
    for equ in src_unit.equipments:
        if equ!=null:
            total_def=total_def+equ.get_q_mdef()
    return total_def

static func cal_mdef_add(src_unit):
    return floor(src_unit.get_int() + (src_unit.get_vit() / 5) + (src_unit.get_dex() / 5) + (src_unit.blv / 4))

static func cal_mov_spd(src_unit):
    return 6

static func cal_equip_atk(src_unit):
    var total_p_atk=0
    for equip in src_unit["equipments"]:
        if equip!=null:
            var q_atk = equip.get_atk()
            total_p_atk=total_p_atk+q_atk
    return total_p_atk

static func cal_unit_atk(src_unit):
    return floor((src_unit.blv / 4) + src_unit.get_str() + (src_unit.get_dex() / 5) + (src_unit.get_luk() / 3))
    
static func cal_static_atk(src_unit): #atk
    var u_atk=cal_unit_atk(src_unit)
    var q_atk=cal_equip_atk(src_unit)
    return u_atk+q_atk

static func cal_hit(src_unit): #hit
    return int(75+src_unit.blv+src_unit.get_dex()+src_unit.get_luk()/3)

static func cal_flee(src_unit): #flee
    return int(src_unit.blv+src_unit.get_agi()+src_unit.get_luk()/5)

static func cal_def_mul(src_unit): #def_mul
    var total_def=0
    for equ in src_unit.equipments:
        if equ!=null:
            total_def=total_def+equ.get_q_def()
    return total_def

static func cal_def_add(src_unit): #def_add
    return int(src_unit.get_vit()/2+src_unit.get_agi()/5+src_unit.blv/2)

static func cal_max_hp(src_unit): #max_hp
    var job_info = Config.job_info[src_unit.job]
    var max_hp=job_info["init_hp"]
    if src_unit.blv>1:
        for i in range(2,src_unit.blv):
            max_hp=max_hp+job_info["max_hp_inc_lv"]*i
    return int(max_hp)

static func cal_max_sp(src_unit): #max_sp
    var job_info = Config.job_info[src_unit.job]
    var max_sp=job_info["init_sp"]
    if src_unit.blv>1:
        for i in range(2,src_unit.blv):
            max_sp=max_sp+job_info["max_sp_inc_lv"]*i
    return int(max_sp)

static func cal_cri(src_unit): #crit
    return int(src_unit.get_luk()*0.3)

static func cal_m_damage(src, target):
    return floor(src.matk_min*(1.0-target.mdef_mul/100.0)-target.mdef_add)

static func cal_p_damage(src, target):
    var raw_atk_min = floor(src.atk_min*(1.0-target.def_mul/100.0)-target.def_add)
    var raw_atk_max = floor(src.atk_max*(1.0-target.def_mul/100.0)-target.def_add)
    var f_atk = Global.rng.randi_range(raw_atk_min,raw_atk_max)
    if f_atk<0:
        f_atk=0
    return f_atk

static func cal_p_cri_damage(src, _target):
    return src.atk_max

static func check_hit(src_unit, tar_unit):
    var chance = src_unit.hit-tar_unit.flee
    if chance<0:
        chance=0
    if chance>100:
        chance=100
    var temp_rand = Global.rng.randi_range(0,100)
    if temp_rand<chance:
        return true
    else:
        return false

static func check_cri(src_unit, tar_unit):
    var chance=src_unit.cri
    var temp_rand = Global.rng.randi_range(0,100)
    if temp_rand<chance:
        return true
    else:
        return false

