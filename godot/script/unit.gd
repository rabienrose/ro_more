extends Node2D

class_name Unit

var map
var frame_delta
var cur_pos=null

var mov_spd=64
var atk=5
var hp=20
var atk_range=1
var atk_spd=1
var b_dead=false
var bufs={}
var last_pos=null
var uid=-1
var u_type

export (NodePath) var hp_bar_path
export (NodePath) var atk_bar_path

func attack(target):
    var die = target.damage(atk)
    if die:
        on_target_die(target)

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
    get_node(hp_bar_path).text="hp:"+str(hp)
    get_node(atk_bar_path).text="atk:"+str(atk)

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


