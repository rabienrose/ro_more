extends Skill

func on_target_skill(tar_unit):
    var sc1={
        "name":"atk_mul",
        "val":Global.get_val_by_lv(info["atk_mul"], cur_lv)
    }
    var sc2={
        "name":"hit_mul",
        "val":Global.get_val_by_lv(info["hit_mul"], cur_lv)
    }
    var sc3={
        "name":"effect",
        "effect_name":"stun",
    }
    tar_unit.add_state_change(sc1)
    tar_unit.add_state_change(sc2)
    tar_unit.add_state_change(sc3)
    tar_unit.do_melee_attack()
    tar_unit.remove_state_change(sc1)
    tar_unit.remove_state_change(sc2)
    tar_unit.remove_state_change(sc3)