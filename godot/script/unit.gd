extends Node2D

class_name Unit

signal on_hitted(other)

export (NodePath) var board_path
export (NodePath) var flying_text_path
export (Resource) var damage_text_res
export (Resource) var cri_text_res
export (Resource) var miss_text_res
export (Resource) var heal_text_res

enum {MISS_FLYING, NORMAL_FLYING, HEAL_FLYING, CRI_FLYING, SP_FLYING}

var map
var flying_text

var uid=-1
var u_type="none"

var frame_delta

var cur_pos=null
var b_dead=false
var last_pos=null

var blv=1
var sp=1
var hp=1

var max_hp=10
var max_sp=10

var matk_min=0
var matk_max=0
var atk_min=5
var atk_max=5
var atk_range=1
var atk_spd=1

var def_mul=0
var def_add=0
var mdef_mul=0
var mdef_add=0

var hit=100
var flee=0
var cri=0
var mov_spd=64

var tween

var bufs={}
var state_changes={}

var text_color_property="custom_colors/font_color"

func show_flying_text(val, text_type):
    var dmg_text=null
    if text_type==NORMAL_FLYING:
        dmg_text = damage_text_res.instance()
        dmg_text.text=str(val)
    elif text_type==MISS_FLYING:
        dmg_text = miss_text_res.instance()
        dmg_text.text=val
    elif text_type==CRI_FLYING:
        dmg_text = cri_text_res.instance()
        dmg_text.text=str(val)
    elif text_type==HEAL_FLYING:
        dmg_text = heal_text_res.instance()
        dmg_text.text=str(val)
    
    flying_text.add_child(dmg_text)
    var h_offset=-dmg_text.rect_size.x/2
    tween.interpolate_property(dmg_text,"rect_position", Vector2(h_offset,0),Vector2(h_offset,-70),2,Tween.TRANS_LINEAR,Tween.EASE_OUT)
    # tween.interpolate_property(dmg_text,"rect_scale", Vector2(0.5,0.5),Vector2(1.5,1.5),2,Tween.TRANS_LINEAR,Tween.EASE_OUT)
    var color_s=dmg_text.get(text_color_property)
    var color_e=Color(color_s.r, color_s.g, color_s.b,0.0)
    tween.interpolate_property(dmg_text,"custom_colors/font_color", color_s,color_e,2,Tween.TRANS_LINEAR,Tween.EASE_IN)
    tween.start()

func flying_text_done( text_obj, key):
    text_obj.queue_free()

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

func do_attack(target, b_magic):
    var damage=0
    var b_cri=false
    if b_magic==false:
        b_cri = StatusCal.check_cri(self,target)
        if b_cri==false:
            var b_hit = StatusCal.check_hit(self,target)
            if b_hit==false:
                show_flying_text("miss",MISS_FLYING)
                return
            damage = StatusCal.cal_p_damage(self,target)
        else:
            damage = StatusCal.cal_p_cri_damage(self,target)
    else:
        damage = StatusCal.cal_m_damage(self,target)
    if damage==0:
        show_flying_text("miss",MISS_FLYING)
    else:
        target.emit_signal("on_hitted", self)
        var die = target.damage(damage, b_cri)
        if die:
            on_target_die(target)
        

func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        for buf in bufs:
            bufs[buf].free()
        bufs={}

func on_target_die(target):
    pass

func on_die():
    pass

func heal(heal_amount):
    if hp==max_hp:
        return
    hp=hp+heal_amount
    var heal_act=heal_amount
    if hp>max_hp:
        heal_act=heal_amount-(hp-max_hp)
        hp=max_hp
    show_flying_text(heal_act,HEAL_FLYING)
    update_board_hp()

func damage(dmg_amount, b_cri):
    if b_cri:
        show_flying_text(str(dmg_amount), CRI_FLYING)
    else:
        show_flying_text(str(dmg_amount), NORMAL_FLYING)
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
    flying_text= get_node(flying_text_path)
    tween=Tween.new()
    add_child(tween)
    tween.connect("tween_completed", self, "flying_text_done")

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
