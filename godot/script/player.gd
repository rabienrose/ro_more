extends Unit

var sprite_name="player"

var routine_dict={}

var cur_routine=""

var cam

var inventory={}

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
    return info

func init_with_info(info):
    str_=info["str"]
    agi_=info["agi"]
    vit_=info["vit"]
    int_=info["int"]
    dex_=info["dex"]
    bexp=info["exp"]
    blv=info["lv"]
    jobexp=info["jobexp"]
    joblv=info["joblv"]
    hp=info["hp"]
    sp=info["sp"]
    job=info["job"]
    max_hp= StatusCal.cal_max_hp(self)
    max_sp= StatusCal.cal_max_sp(self)
    update_board()

func _input(event):
    if event is InputEventMouseButton:
        if event.pressed==false:
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

func set_cell_pos(pos_c):
    .set_cell_pos(pos_c)
    # map.cam.set_pos_c(pos_c, true)

func _ready():
    cam=get_node("Camera2D")
    mov_spd=200
    atk=10
    update_board()
    u_type=Global.PLAYER
    routine_dict["walk_to"]=WalkTo.new()
    routine_dict["walk_to"].on_create(self)
    routine_dict["follow_atk"]=FollowAttack.new()
    routine_dict["follow_atk"].on_create(self)
