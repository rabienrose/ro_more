extends Unit

var sprite_name="player"

enum {
        EQI_ACC_L,
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

var routine_dict={}
var cur_routine=""
var cam
var inventory={}
var equipments=[]

var str_
var agi_
var vit_
var int_
var dex_
var luk_
var joblv
var job
var jobexp
var baseexp
var skills=[]
var attr_point=0
var skill_point=0
var char_id
var cur_skill_state=null

var b_master=false

func get_str():
    return str_

func get_agi():
    return agi_

func get_vit():
    return vit_

func get_int():
    return int_

func get_dex():
    return dex_

func get_luk():
    return luk_

func update_cam_pos(delta_p):
    cam.set_delay(-delta_p)

func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        for routine_name in routine_dict:
            routine_dict[routine_name].free()
        routine_dict={}

func get_save_info():
    var info={}
    info["pos_x"]=cur_pos.x
    info["pos_y"]=cur_pos.y
    info["hp"]=hp
    info["sp"]=sp
    info["str"]=str_
    info["agi"]=agi_
    info["vit"]=vit_
    info["int"]=int_
    info["dex"]=dex_
    info["luk"]=luk_
    info["exp"]=baseexp
    info["lv"]=blv
    info["jobexp"]=jobexp
    info["joblv"]=joblv
    info["job"]=job
    info["skill_point"]=skill_point
    info["attr_point"]=attr_point
    return info

func sync_ui():
    UiMsg.emit_signal("attribute_change","str", str_)
    UiMsg.emit_signal("attribute_change","agi", agi_)
    UiMsg.emit_signal("attribute_change","vit", vit_)
    UiMsg.emit_signal("attribute_change","int", int_)
    UiMsg.emit_signal("attribute_change","dex", dex_)
    UiMsg.emit_signal("attribute_change","luk", luk_)

func on_create(_map, info):
    .on_create(_map, info)
    str_=info["str"]
    agi_=info["agi"]
    vit_=info["vit"]
    int_=info["int"]
    dex_=info["dex"]
    luk_=info["luk"]
    baseexp=info["exp"]
    blv=info["lv"]
    jobexp=info["jobexp"]
    joblv=info["joblv"]
    hp=info["hp"]
    sp=info["sp"]
    job=info["job"]
    name=info["name"]
    skill_point=info["skill_point"]
    attr_point=info["attr_point"]
    char_id=info["char_id"]
    max_hp= StatusCal.cal_max_hp(self)
    max_sp= StatusCal.cal_max_sp(self)
    atk_min = StatusCal.cal_atk_min(self)
    atk_max = StatusCal.cal_atk_max(self)
    matk_min = StatusCal.cal_matk_min(self)
    matk_max = StatusCal.cal_matk_max(self)
    atk_range = StatusCal.cal_atk_range(self)
    mdef_mul = StatusCal.cal_mdef_mul(self)
    mdef_add = StatusCal.cal_mdef_add(self)
    def_mul = StatusCal.cal_def_mul(self)
    def_add = StatusCal.cal_def_add(self)
    mov_spd = StatusCal.cal_mov_spd(self)
    hit = StatusCal.cal_hit(self)
    flee = StatusCal.cal_flee(self)
    cri = StatusCal.cal_cri(self)
    var body_res = load(Global.body_res_path+info["body_v"]+".tscn")
    var body_obj = body_res.instance()
    add_child(body_obj)
    update_board()
    cam=get_node("Camera2D")
    if b_master:
        sync_ui()
        cam.current=true
    else:
        remove_child(cam)
    UiMsg.emit_signal("attr_point_change",attr_point)
    var skills_player = map.game.get_char_skills(char_id)
    for skill in skills_player:
        var s_info = Config.skill_info[skill["skill_name"]]
        s_info["skill_name"]=skill["skill_name"]
        var script_path = Global.skill_class_path+s_info["class"]+".gd"
        var skill_obj = load(script_path).new()
        skill_obj.on_create(self, s_info)
        skills.append(skill_obj)
        skill_obj.on_attach()
        UiMsg.emit_signal("add_skill",s_info["skill_name"],{"title":s_info["title"]})

func _input(event):
    if b_master==false:
        return
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed==false:
            var mouse_pos=map.get_mouse_cell_pos()
            var click_cid=map.pos_2_cind(mouse_pos)
            if map.cells[click_cid].b_free==false:
                pass
            else:
                if cur_routine!="" and routine_dict[cur_routine].state==Routine.RUNNING:
                    routine_dict[cur_routine].stop_routine()
                var cell_mob=map.cells[click_cid].has_mob()
                if cell_mob!=null:
                    routine_dict["follow_atk"].set_tar(cell_mob)
                    routine_dict["follow_atk"].reset_run()
                    cur_routine="follow_atk"
                else:
                    routine_dict["walk_to"].set_tar_pos(mouse_pos)
                    routine_dict["walk_to"].reset_run()
                    cur_routine="walk_to"
    # elif event is InputEventMouseMotion:
    #     print("Mouse Motion at: ", event.position)

func _process(_delta):
    if cur_routine!="" and routine_dict[cur_routine].state==Routine.RUNNING:
        routine_dict[cur_routine].act()
    for skill in skills:
        if skill.need_update:
            skill.on_update()

func on_die():
    routine_dict[cur_routine].stop_routine()
    var cell = map.get_rand_free_cell()
    set_cell_pos(cell.pos)
    hp=int(max_hp/2)
    sp=0
    b_dead=false
    update_board()

func on_target_die(target):
    baseexp=baseexp+target.baseexp

func on_reqeust_add_attribute(attr_name):
    var attr_val=get(attr_name+"_")
    if attr_val+1>=100:
        return
    var cost_point = Config.get_attr_point_cost(attr_val)
    if cost_point<=attr_point:
        attr_point=attr_point-cost_point
        set(attr_name+"_",attr_val+1)
        UiMsg.emit_signal("attribute_change",attr_name, attr_val+1)
        UiMsg.emit_signal("attr_point_change",attr_point)

func find_skill(skill_name):
    for skill in skills:
        if skill.skill_name==skill_name:
            return skill
    return null

func on_request_use_skill(skill_name):
    var skill_obj=find_skill(skill_name)
    if cur_skill_state!=null:
        return
    if skill_obj.target=="none":
        return 
    else:
        if skill_obj.target_type!="self":
            cur_skill_state={"name":skill_name,"state":"choose"}
        else:
            cur_skill_state={"name":skill_name,"state":"cast"}

func _ready():
    equipments.resize(EQI_MAX)
    for i in range(EQI_MAX):
        equipments[i]=null
    u_type=Global.PLAYER
    routine_dict["walk_to"]=WalkTo.new()
    routine_dict["walk_to"].on_create(self)
    routine_dict["follow_atk"]=FollowAttack.new()
    routine_dict["follow_atk"].on_create(self)
    UiMsg.connect("reqeust_add_attribute",self, "on_reqeust_add_attribute")
    UiMsg.connect("request_use_skill",self, "on_request_use_skill")
    
