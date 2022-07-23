extends Object
class_name PathFind

func node_cost(d_ind):
    if d_ind==1 or d_ind==3 or d_ind==5 or d_ind==7:
        return 1.4142
    else:
        return 1

func get_min_score_node(node_list):
    var min_score=-1
    var min_node=-1
    for key in node_list:
        if min_score==-1 or min_score>node_list[key]["score"]:
            min_score=node_list[key]["score"]
            min_node=key
    return node_list[min_node]

func find_path(map, s_pos, e_pos):
    var done_nodes={}
    var pending_nodes={}
    var t_id= map.pos_2_cind(s_pos)
    var cur_cell_id=t_id
    var new_node={}
    new_node["parent_node"]=null
    new_node["cost"]=0
    new_node["cid"]=t_id
    new_node["dist"]=(e_pos-s_pos).length()
    new_node["pos"]=s_pos
    new_node["score"]=new_node["dist"]+new_node["cost"]
    done_nodes[cur_cell_id]=new_node
    var cur_node=done_nodes[cur_cell_id]
    var max_try=1000
    var try_count=0
    while true:
        try_count=try_count+1
        if try_count>max_try:
            return []
        if (cur_node["pos"]-e_pos).length()<0.1:
            var path_inv=[]
            var temp_cur_node=cur_node
            path_inv.append(cur_node["cid"])
            while true:
                if temp_cur_node.parent_node!=null:
                    path_inv.append(temp_cur_node.parent_node)
                    temp_cur_node=done_nodes[temp_cur_node.parent_node]
                else:
                    break
            var path=[]
            path.resize(path_inv.size())
            for i in range(path_inv.size()):
                var _id=path_inv[path_inv.size()-1-i]
                path[i]=done_nodes[_id]["pos"]
            return path
        for i in range(8):
            var t_dir = Global.dir_2_vec(i)
            var next_pos=cur_node["pos"]+t_dir
            if map.check_pos_in_map(next_pos)==false:
                continue
            var next_c_ind = map.pos_2_cind(next_pos)
            if map.cells[next_c_ind].b_free==false:
                continue
            if next_c_ind in done_nodes:
                continue
            elif next_c_ind in pending_nodes:
                var next_node=pending_nodes[next_c_ind]
                if next_node["cost"]>cur_node["cost"]+node_cost(i):
                    next_node["cost"]=cur_node["cost"]+node_cost(i)
                    next_node["parent_node"]=cur_node["cid"]
                    next_node["score"]=next_node["dist"]+next_node["cost"]
            else:
                new_node={}
                new_node["parent_node"]=cur_node["cid"]
                new_node["cost"]=cur_node["cost"]+node_cost(i)
                new_node["cid"]=next_c_ind
                new_node["dist"]=(e_pos-next_pos).length()
                new_node["pos"]=next_pos
                new_node["score"]=new_node["dist"]+new_node["cost"]
                pending_nodes[next_c_ind]=new_node
        cur_node = get_min_score_node(pending_nodes)
        done_nodes[cur_node["cid"]]=cur_node
        pending_nodes.erase(cur_node["cid"])
