extends Object

class_name Cell

var pos=Vector2(0,0)
var b_free
var units={}

func has_mob():
    if units.size()==0:
        return null
    else:
        for uid in units:
            if units[uid].u_type==Global.MOB:
                return units[uid]
        return null

