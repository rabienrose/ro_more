extends Unit

var sprite_name="player"

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

var b_master=false

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
    return info

func sync_ui():
    UiMsg.emit_signal("on_attribute_change","str", str_)
    UiMsg.emit_signal("on_attribute_change","agi", agi_)
    UiMsg.emit_signal("on_attribute_change","vit", vit_)
    UiMsg.emit_signal("on_attribute_change","int", int_)
    UiMsg.emit_signal("on_attribute_change","dex", dex_)
    UiMsg.emit_signal("on_attribute_change","luk", luk_)

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
    max_hp= StatusCal.cal_max_hp(self)
    max_sp= StatusCal.cal_max_sp(self)
    atk = StatusCal.cal_atk(self)
    var body_res = load(Global.body_res_path+info["body_v"]+".tscn")
    var body_obj = body_res.instance()
    add_child(body_obj)
    update_board()
    if b_master:
        sync_ui()

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

func _ready():
    equipments.resize(EQI_MAX)
    for i in range(EQI_MAX):
        equipments[i]=null
    cam=get_node("Camera2D")
    if b_master:
        cam.current=true
    else:
        remove_child(cam)
    u_type=Global.PLAYER
    routine_dict["walk_to"]=WalkTo.new()
    routine_dict["walk_to"].on_create(self)
    routine_dict["follow_atk"]=FollowAttack.new()
    routine_dict["follow_atk"].on_create(self)
