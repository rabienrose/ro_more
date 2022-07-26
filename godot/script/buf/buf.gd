extends Object

class_name Buf

enum {PEND, RUN, END}

var owner
var s_time=0
var duration=5
var state=PEND
var buf_name=""
var buf_group="none"

func on_create(_owner):
    owner=_owner

func start():
    s_time=OS.get_ticks_msec()
    state=RUN
    print(buf_name+" start")

func update():
    if state==RUN:
        if !is_instance_valid(owner) or owner.b_dead==true:
            state=END
            print(buf_name+" end")
        if OS.get_ticks_msec()-s_time>duration*1000:
            state=END
            print(buf_name+" end")
