extends Node2D

var tween

func tween_done_cb(object, key):
    object.queue_free()

func timer_cb():
    var text_res = load("res://ui/flying_text_damage.tscn")
    var text_obj=text_res.instance()
    get_node("Test").add_child(text_obj)
    tween.interpolate_property(text_obj,"rect_position", Vector2(0,0), Vector2(0,-70),2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    tween.start()

func _ready():
    tween = Tween.new()
    add_child(tween)
    tween.connect("tween_completed",self, "tween_done_cb")
    
    var timer = Timer.new()
    add_child(timer)
    timer.connect("timeout", self, "timer_cb")
    timer.wait_time=0.5
    # timer.one_shot=true
    timer.start()



