extends Node2D

class_name Map

export var map_name=""
var map_w
var map_h
var block_w
var block_h
var cells=[]
var free_cells=[]
var mobs_root
var players_root
var blocks_unit=[]
var BLOCK_SIZE=5
var game


func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        pass

func check_unit_cell(unit):
    var cid=pos_2_cind(unit.cur_pos)
    if not unit.uid in cells[cid]["units"]:
        print("cell unit error!!!")
        assert(false)

func check_unit_block(unit):
    var bid=pos_2_block_id(unit.cur_pos)
    if not unit.uid in blocks_unit[bid]:
        print("block unit error!!!")
        assert(false)

func remove_unit(unit):
    if unit.cur_pos!=null:
        check_unit_cell(unit)
        check_unit_block(unit)
        var cid=pos_2_cind(unit.cur_pos)
        cells[cid]["units"].erase(unit.uid)
        var bid = pos_2_block_id(unit.cur_pos)
        blocks_unit[bid].erase(unit.uid)
    unit.queue_free()

func print_cell_units():
    var total=0
    for i in range(cells.size()):
        total=total+cells[i]["units"].size()
    print(total)

func print_block_units():
    var total=0
    for i in range(blocks_unit.size()):
        total=total+blocks_unit[i].size()
    print(total)

func on_unit_cell_change(unit, old_cpos, new_cpos):
    var new_bid=pos_2_block_id(new_cpos)
    var new_cid=pos_2_cind(new_cpos)
    if old_cpos!=null:
        check_unit_cell(unit)
        check_unit_block(unit)
        var old_bid=pos_2_block_id(old_cpos)
        var old_cid=pos_2_cind(old_cpos)
        cells[old_cid]["units"].erase(unit.uid)
        if old_bid!=new_bid:
            blocks_unit[old_bid].erase(unit.uid)
    cells[new_cid]["units"][unit.uid]=unit
    blocks_unit[new_bid][unit.uid]=unit
    # print_cell_units()
    # print_block_units()

func get_units_in_area(area, unit_type):
    var blocks = get_related_blocks(area)
    var out_unit=[]
    for block_id in blocks:
        if blocks_unit[block_id].size()>0:
            for uid in blocks_unit[block_id]:
                var unit=blocks_unit[block_id][uid]
                if unit.u_type==unit_type:
                    out_unit.append(unit)

func get_related_blocks(area):
    var b_min = pos_2_block(area.position)
    var b_max = pos_2_block(area.end)
    var blocks=[]
    for i in range(b_min.x,b_max.x+1):
        for j in range(b_min.y,b_max.y+1):
            blocks.append(block_2_block_id(Vector2(i,j)))
    return blocks

func cid_2_block_id(cid):
    return pos_2_block_id(cind_2_pos(cid)) 

func block_2_block_id(pos_b):
    return pos_b.y*block_w+pos_b.x

func pos_2_block(pos_c):
    return Vector2(floor(pos_c.x/BLOCK_SIZE), floor(pos_c.y/BLOCK_SIZE))

func pos_2_block_id(pos_c):
    return block_2_block_id(pos_2_block(pos_c))

func pos_2_cind(pos):
    return int(pos.y*map_w+pos.x)

func cind_2_pos(cid):
    return Vector2(cid%map_w, floor(cid/map_w))

func get_rand_free_cell():
    var r_ind = Global.rng.randi_range(0,free_cells.size()-1)
    return free_cells[r_ind]

func get_rand_free_cell_in_area(pos, range_cell):
    var free_cell_temp=[]
    for x in range(pos.x-range_cell, pos.x+range_cell+1):
        for y in range(pos.y-range_cell, pos.y+range_cell+1):
            var temp_p=Vector2(x,y)
            if check_pos_in_map(temp_p):
                var cell=cells[pos_2_cind(temp_p)]
                if cell.b_free==true:
                    free_cell_temp.append(cell)
    var r_ind = Global.rng.randi_range(0,free_cell_temp.size()-1)
    return free_cell_temp[r_ind]

func pos_2_pixel(pos):
    return Vector2(Global.pixel_p_cell*pos.x+Global.pixel_p_cell/2, Global.pixel_p_cell*pos.y+Global.pixel_p_cell/2)

func pixel_2_pos(p_pos):
    return Vector2(floor(p_pos.x/Global.pixel_p_cell), floor(p_pos.y/Global.pixel_p_cell))

func cal_path(s_pos, e_pos, max_step):
    return PathFind.find_path(self, s_pos, e_pos, max_step)

func check_pos_in_map(pos):
    if pos.x<0 or pos.y<0 or pos.x>=map_w or pos.y>=map_h:
        return false
    else:
        return true

func get_mouse_cell_pos():
    var pixel_p = get_global_mouse_position()
    return pixel_2_pos(pixel_p)

func char_join(char_name):
    var char_info = game.get_char_info(char_name)
    var player_res = load(Global.player_path)
    var player = player_res.instance()
    players_root.add_child(player)
    player.b_master=true
    player.on_create(self, char_info)
    player.set_cell_pos(Vector2(char_info["pos_x"], char_info["pos_y"]))

func on_create(_game):
    game=_game

func _ready():
    mobs_root=get_node("Mobs")
    players_root=get_node("Players")
    var f = File.new()
    f.open(Global.map_data_path+map_name+".png", File.READ)
    var data_bytes=f.get_buffer(f.get_len())
    var image=Image.new()
    image.load_png_from_buffer(data_bytes)
    cells=[]
    map_w=image.get_width()
    map_h=image.get_height()
    cells.resize(map_w*map_h)
    block_w=ceil(map_w/BLOCK_SIZE)
    block_h=ceil(map_h/BLOCK_SIZE)
    blocks_unit.resize(block_h*block_w)
    for i in range(block_h*block_w):
        blocks_unit[i]={}
    image.lock()
    for y in range(map_h):
        for x in range(map_w):
            var new_cell=Cell.new()
            new_cell.pos.x=x
            new_cell.pos.y=y
            var c = image.get_pixel(x,y)
            if c.r==1.0:
                new_cell.b_free=true
                free_cells.append(new_cell)
            else:
                new_cell.b_free=false
            cells[pos_2_cind(Vector2(x,y))]=new_cell
    image.unlock()

    var spawn_info=Config.map_info[map_name]["mobs"]
    for mob in spawn_info:
        for _i in range(mob["count"]):
            var mob_res = load(Global.mob_path)
            var mob_obj = mob_res.instance()
            mobs_root.add_child(mob_obj)
            mob_obj.on_create(self, Config.mob_info[mob["name"]])
            var cell = get_rand_free_cell()
            mob_obj.set_cell_pos(cell.pos)

    var save_timer=Timer.new()
    add_child(save_timer)
    save_timer.name="save_timer"
    save_timer.wait_time=5
    save_timer.connect("timeout", self, "save_map")
    save_timer.start()

func save_map():
    for player in players_root.get_children():
        var info = player.get_save_info()
        game.save_char_info(player.name, info)



