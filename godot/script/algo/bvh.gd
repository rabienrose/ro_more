extends Object

class_name BVH

class MyCustomSorterX:
    static func sort_ascending(a, b):
        if a["center"].x < b["center"].x:
            return true
        return false

class MyCustomSorterY:
    static func sort_ascending(a, b):
        if a["center"].y < b["center"].y:
            return true
        return false

class MyCustomSorterZ:
    static func sort_ascending(a, b):
        if a["center"].z < b["center"].z:
            return true
        return false

var root_node
class bvh_node:
    var c1
    var c2
    var p
    var aabb:AABB
    var leaf

func create_bvh_node(faces, parent):
    var _node=bvh_node.new()
    _node.aabb=get_merged_aabb(faces)
    if faces.size()==1:
        _node.leaf=faces[0]
    _node.p = parent
    return _node

func get_merged_aabb(faces):
    var aabb=faces[0]["aabb"]
    for face in faces:
        aabb=aabb.merge(face["aabb"])
    return aabb

func _create_bvh(p_node, faces): 
    if faces.size()==1:
        pass
    else:
        var dim_id = p_node.aabb.get_longest_axis_index()
        var sorter=null
        if dim_id==Vector3.AXIS_X:
            sorter=MyCustomSorterX.new()
        if dim_id==Vector3.AXIS_Y:
            sorter=MyCustomSorterY.new()
        if dim_id==Vector3.AXIS_Z:
            sorter=MyCustomSorterZ.new()
        faces.sort_custom(sorter, "sort_ascending")
        var split_id=floor(faces.size()/2)
        var c_faces1=[]
        for i in range(split_id):
            c_faces1.append(faces[i])
        var c_faces2=[]
        for i in range(split_id,faces.size()):
            c_faces2.append(faces[i])
        p_node.c1 = create_bvh_node(c_faces1, p_node)
        _create_bvh(p_node.c1, c_faces1)
        p_node.c2 = create_bvh_node(c_faces2, p_node)
        _create_bvh(p_node.c2, c_faces2)

func create_bvh(faces):
    root_node = create_bvh_node(faces, null)
    _create_bvh(root_node, faces)

func _ray_query_aabb(from, dir,node, result_faces):
    var result = node.aabb.intersects_segment(from, from+dir*200)
    if result:
        if node.leaf!=null:
            result_faces.append(node.leaf)
        else:
            _ray_query_aabb(from, dir,node.c1,result_faces)
            _ray_query_aabb(from, dir,node.c2,result_faces)

func ray_query_aabb(from, dir):
    var result_aabbs=[]
    _ray_query_aabb(from, dir,root_node,result_aabbs)
    return result_aabbs
