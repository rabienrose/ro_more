extends Node2D

export (NodePath) var ground_path
export (NodePath) var cam_path

var map_name="map2"
var mob_count=3
var mob_name="mob"
var map_w
var map_h
var cells
var free_cells=[]
var units_root
var path_finder

func pos_2_cind(pos):
    return int(pos.y*map_w+pos.x)

func cind_2_pos(cid):
    return Vector2(cid%map_w, floor(cid/map_w))

func get_rand_free_cell():
    var r_ind = Global.rng.randi_range(0,free_cells.size()-1)
    return free_cells[r_ind]

func pos_2_pixel(pos):
    return Vector2(Global.pixel_p_cell*pos.x+Global.pixel_p_cell/2, Global.pixel_p_cell*pos.y+Global.pixel_p_cell/2)

func cal_path(s_pos, e_pos):
    return path_finder.find_path(self, s_pos, e_pos)

func _ready():
    path_finder=PathFind.new()
    units_root=get_node("Units")
    var f = File.new()
    f.open(Global.map_data_path+map_name+".png", File.READ)
    var data_bytes=f.get_buffer(f.get_len())
    var image=Image.new()
    image.load_png_from_buffer(data_bytes)
    cells=[]
    map_w=image.get_width()
    map_h=image.get_height()
    cells.resize(map_w*map_h)
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
    for i in range(mob_count):
        var mob_res = load(Global.mob_res_path+mob_name+".tscn")
        var mob_obj = mob_res.instance()
        mob_obj.on_create(self)
        var cell = get_rand_free_cell()
        mob_obj.set_cell_pos(cell.pos)
        units_root.add_child(mob_obj)

