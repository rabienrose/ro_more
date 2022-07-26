extends Skill

var state_change=null

func set_lv(lv):
    .set_lv(lv)
    on_detach()
    on_attach()

func on_attach():
    state_change={
        "name":"weapon_mastery",
        "weapon_type":info["weapon_type"],
        "val":info["val"][cur_lv]
    }
    unit.add_state_change(state_change)

func on_detach():
    unit.remove_state_change("weapon_mastery", state_change)