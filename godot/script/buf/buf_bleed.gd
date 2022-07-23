extends Buf

class_name BufBleed

var amount=6
var period=1
var last_trig_t=0

func update():
    .update()
    if state==RUN:
        var c_time=OS.get_ticks_msec()
        if c_time - last_trig_t>period*1000:
            last_trig_t=c_time
            owner.damage(amount)

func on_create(_owner):
    .on_create(_owner)
    duration=10
    buf_name="bleed"
        
