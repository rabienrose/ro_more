extends Node2D

class_name Unit

signal on_hitted(other)

export (NodePath) var board_path

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
var sp
var atk_range=1
var atk_spd=1
var max_hp
var max_sp
var hit
var flee
var cri
var matk_min
var matk_max
var speed
var aspd_rate
var def_mul
var def_add
var mdef
var blv
var bufs={}
var state_changes={}

func add_state_change(info):
    if info["name"] in state_changes:
        state_changes[info["name"]].append(info)
    else:
        state_changes[info["name"]]=[info]

func remove_state_change(info):
    if info["name"] in state_changes:
        state_changes[info["name"]].erase(info)

func update_cam_pos(delta_p):
    pass

func do_melee_attack(target):
    var die = target.damage(atk)
    if die:
        on_target_die(target)
    target.emit_signal("on_hitted",self)
    # var b_hit = StatusCal.check_hit(self,target,1)
    # if b_hit:
    #     var damage = 0
    #     if equips[EQI_HAND_R]==null or equips[EQI_HAND_R]!=null and equips[EQI_HAND_R].atk_type==Equip.MELEE:
    #         damage=StatusCal.cal_melee_damage(self,target)
    #     elif equips[EQI_HAND_R]!=null and equips[EQI_HAND_R].atk_type==Equip.RANGE:
    #         damage=StatusCal.cal_range_damage(self,target)
    #     print("damage: ",damage)
    #     var die = target.damage(damage)
    #     if die:
    #         on_target_die(target)
    # else:
    #     print("miss")

func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        for buf in bufs:
            bufs[buf].free()
        bufs={}

func on_target_die(target):
    pass

func on_die():
    pass

func damage(dmg_amount):
    hp=hp-dmg_amount
    if hp<=0:
        b_dead=true
        on_die()
        return true
    update_board_hp()
    return false

func update_board_hp():
    get_node(board_path).update_up(hp, max_hp)

func update_board_sp():
    get_node(board_path).update_sp(sp, max_sp)

func update_board_name():
    get_node(board_path).update_name(name)

func update_board():
    update_board_hp()
    update_board_sp()
    update_board_name()

func set_cell_pos(pos_c):
    map.on_unit_cell_change(self, cur_pos, pos_c)
    cur_pos=pos_c
    position=map.pos_2_pixel(pos_c)

func on_create(_map, info):
    map=_map

func _ready():
    uid=Global.get_new_unit_id()

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

func _on_Area_input_event(viewport:Node, event:InputEvent, shape_idx:int):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_RIGHT and event.is_pressed():
            UiMsg.emit_signal("show_unit_detail",self)
