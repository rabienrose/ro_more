extends Object
class_name StatusCal

static func cal_melee_damage(src_unit,tar_unit):
    var status_atk = floor((src_unit.lv / 4) + src_unit.str_ + (src_unit.dex_ / 5) + (src_unit.luk_ / 3))
    # var WeaponATK = floor[((BaseWeaponDamage + Variance + StatBonus + RefinementBonus + OverUpgradeBonus) × SizePenalty]

static func cal_range_damage(src_unit,tar_unit):
    pass

static func cal_atk(src_unit):
    pass

static func cal_max_hp(src_unit):
    var job_info = Config.job_info[src_unit.job]
    var max_hp=job_info["init_hp"]
    if src_unit.lv>1:
        for i in range(2,src_unit.lv):
            max_hp=max_hp+job_info["max_hp_inc_lv"]*i
    return max_hp

static func cal_max_sp(src_unit):
    var job_info = Config.job_info[src_unit.job]
    var max_sp=job_info["init_sp"]
    if src_unit.lv>1:
        for i in range(2,src_unit.lv):
            max_sp=max_sp+job_info["max_sp_inc_lv"]*i
    return max_sp

static func check_hit(src_unit, tar_unit, mob_count):
    pass
    # 100 + SkillBonus + [BaseLv + AGI + LUK / 5 + ItemBonus] × {1 - [(Mobs − 2) × 0.1]}
