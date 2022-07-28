extends Spatial

export (Resource) var sel_face_mat_res

var map_w=64
var map_h=64

var state_space

var cells=[]
var faces=[]
var verts=[]
var bvh

var l_pressed=false
var b_l_drag=false
var r_pressed=false
var b_r_drag=false
var cam_platform

var cam

var hori_rot_spd=0.005
var veri_rot_spd=0.005
var pan_spd=0.00139
var zoom_spd=0.9

var sel_cells={}

var sel_mesh_vis=null

func query_face_ray(face, from, dir):
    var v=verts[face["vs"][0]] 
    var v_r=verts[face["vs"][1]]
    var v_rb=verts[face["vs"][2]]
    var v_b=verts[face["vs"][3]]
    var p1 = Geometry.ray_intersects_triangle( from, dir, v, v_r, v_rb)
    var p2 = Geometry.ray_intersects_triangle( from, dir, v, v_rb, v_b)
    var f_col_point=null
    if p1!=null:
        f_col_point=p1
    elif p2!=null:
        f_col_point=p2
    return f_col_point

func get_click_face(screen_pos):
    var from = cam.project_ray_origin(screen_pos)
    var dir= cam.project_ray_normal(screen_pos)
    var result_aabbs = bvh.ray_query_aabb(from, dir)
    var min_face_dist=-1
    var min_face=null
    for face in result_aabbs:
        var col_point = query_face_ray(face, from, dir)
        if col_point!=null:
            var dist_2_cam = (from-col_point).length()
            if min_face_dist <0 or dist_2_cam<min_face_dist:
                min_face_dist=dist_2_cam
                min_face=face
    return min_face

func _input(event):
    if event is InputEventMouseMotion:
        if r_pressed:
            b_r_drag=true
            cam_platform.rotation.y=cam_platform.rotation.y-event.relative.x*hori_rot_spd
            if cam_platform.rotation.y>PI:
                cam_platform.rotation.y=cam_platform.rotation.y-2*PI
            elif cam_platform.rotation.y<-PI:
                cam_platform.rotation.y=cam_platform.rotation.y+2*PI
            cam_platform.rotation.x=cam_platform.rotation.x-event.relative.y*veri_rot_spd
            if cam_platform.rotation.x>0:
                cam_platform.rotation.x=0
            elif cam_platform.rotation.x<-PI/2:
                cam_platform.rotation.x=-PI/2
            
        if l_pressed:
            b_l_drag=true
            var side_dir = cam_platform.to_global(Vector3(1,0,0))-cam_platform.global_transform.origin
            var front_dir = cam_platform.to_global(Vector3(0,0,1))-cam_platform.global_transform.origin
            
            if cam_platform.rotation.x<-PI/4:
                front_dir = cam_platform.to_global(Vector3(0,-1,0))-cam_platform.global_transform.origin
            front_dir.y=0
            front_dir=front_dir.normalized()
            cam_platform.global_transform.origin=cam_platform.global_transform.origin-event.relative.x*side_dir*pan_spd*cam.size
            cam_platform.global_transform.origin=cam_platform.global_transform.origin-event.relative.y*front_dir*pan_spd*cam.size
            
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.is_pressed()==false:
            if b_l_drag==false:
                var sel_face = get_click_face(event.position)
                if sel_face==null:
                    return
                var sel_cell_id=pos_2_ind(sel_face["cell"])
                if sel_cell_id in sel_cells:
                    sel_cells.erase(sel_cell_id) 
                else:
                    sel_cells[sel_cell_id]=cells[sel_cell_id]
                update_selection()
                 
        if event.button_index == BUTTON_LEFT:
            l_pressed=event.is_pressed()
            if l_pressed:
                b_l_drag=false
        if event.button_index == BUTTON_RIGHT:
            r_pressed=event.is_pressed()
            if r_pressed:
                b_r_drag=false
        if event.is_pressed():
            if event.button_index == BUTTON_WHEEL_UP:
                cam.size=cam.size*zoom_spd
                if cam.size<1:
                    cam.size=1
            if event.button_index == BUTTON_WHEEL_DOWN:
                cam.size=cam.size/zoom_spd
                if cam.size>100:
                    cam.size=100

func cal_face_aabb(face):
    face["aabb"]=AABB(verts[face["vs"][0]], Vector3(0,0,0))
    for i in range(4):
        face["aabb"]=face["aabb"].expand(verts[face["vs"][i]])

func cal_face_normal(face):
    var v1=verts[face["vs"][0]] - verts[face["vs"][1]]
    var v2=verts[face["vs"][0]] - verts[face["vs"][2]]
    return -v1.cross(v2)

func update_selection():
    var vertices = PoolVector3Array()
    for sel in sel_cells:
        var cell_face=sel_cells[sel]["faces"][0]
        var normal = cal_face_normal(cell_face)*0.001
        var v=verts[cell_face["vs"][0]]+normal
        var v_r=verts[cell_face["vs"][1]]+normal
        var v_rb=verts[cell_face["vs"][2]]+normal
        var v_b=verts[cell_face["vs"][3]]+normal
        vertices.push_back(v)
        vertices.push_back(v_r)
        vertices.push_back(v_rb)
        vertices.push_back(v)
        vertices.push_back(v_rb)
        vertices.push_back(v_b)

    var arr_mesh = ArrayMesh.new()
    var arrays = []
    arrays.resize(ArrayMesh.ARRAY_MAX)
    arrays[ArrayMesh.ARRAY_VERTEX] = vertices
    arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    sel_mesh_vis.mesh=arr_mesh
    sel_mesh_vis.set_surface_material(0,sel_face_mat_res)

func pos_2_ind(pos):
    return pos.y*map_w+pos.x

func _ready():
    state_space=get_world().direct_space_state
    cam_platform=get_node("CamPlatform")
    cam=get_node("CamPlatform/Camera")
    cells.resize(map_w*map_h)
    faces=[]
    if true:
        verts = PoolVector3Array()
        var indice = PoolIntArray()
        for j in range(map_h):
            for i in range(map_w):
                var cell={}
                var ind=pos_2_ind(Vector2(i,j))    
                cells[ind] = cell
                var face={}
                cell["faces"]=[face,null,null]
                faces.append(face)
                var p=Vector3(i, 0, j)
                var p_ind=verts.size()
                var p_r=Vector3(i+1, 0, j)
                var p_ind_r=p_ind+1
                var p_b=Vector3(i, 0, j+1)
                var p_ind_rb=p_ind+2
                var p_rb=Vector3(i+1, 0, j+1)
                var p_ind_b=p_ind+3
                verts.push_back(p)
                verts.push_back(p_r)
                verts.push_back(p_rb)
                verts.push_back(p_b)
                indice.push_back(p_ind)
                indice.push_back(p_ind_r)
                indice.push_back(p_ind_rb)
                indice.push_back(p_ind)
                indice.push_back(p_ind_rb)
                indice.push_back(p_ind_b)
                face["vs"]=[p_ind,p_ind_r,p_ind_rb,p_ind_b]
                face["center"]=(p+p_r+p_b+p_rb)/4
                face["cell"]=Vector2(i,j)
                cal_face_aabb(face)
        bvh = BVH.new()
        bvh.create_bvh(faces)
        var arr_mesh = ArrayMesh.new()
        var arrays = []
        arrays.resize(ArrayMesh.ARRAY_MAX)
        arrays[ArrayMesh.ARRAY_VERTEX] = verts
        arrays[ArrayMesh.ARRAY_INDEX] = indice
        arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
        ResourceSaver.save("res://mesh.tres", arr_mesh, 32)
        var m = MeshInstance.new()
        m.mesh = arr_mesh
        m.name="Ground"
        add_child(m)
        sel_mesh_vis=MeshInstance.new()
        add_child(sel_mesh_vis)
        
