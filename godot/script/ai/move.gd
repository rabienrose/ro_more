extends Routine

class_name Move

var f_pos
var f_pos_pixel

func set_tar_pos(_f_pos):
    f_pos=_f_pos
    f_pos_pixel=unit.map.pos_2_pixel(f_pos)

func act():
    if state!=RUNNING:
        return
    var r_vec=f_pos_pixel-unit.position
    var r_dist=r_vec.length()
    var next_mov_dist=unit.frame_delta*unit.mov_spd*32
    if r_dist<next_mov_dist:
        state=SUCC
        unit.set_cell_pos(f_pos)
        return
    r_vec=r_vec.normalized()
    var move_d= r_vec*next_mov_dist
    unit.update_cam_pos(move_d)
    unit.position=unit.position+move_d
    
