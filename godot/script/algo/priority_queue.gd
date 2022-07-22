extends Object
class_name PriorityQueue

var temp_list=[]

func insert_new(obj, val):
    if temp_list.size()==0:
        temp_list.append([val,obj])
    else:
        var min_ind=0
        var max_ind=temp_list.size()-1
        while true:
            if max_ind-min_ind<=1:
                break
            var mid_ind=floor((max_ind-min_ind)/2)+min_ind
            if val<temp_list[mid_ind][0]:
                max_ind=mid_ind
            else:
                min_ind=mid_ind
        temp_list.insert(max_ind, [val,obj])


