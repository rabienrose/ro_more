extends HBoxContainer

export (NodePath) var label_path

var attr_name

func set_attr_name(_attr_name):
    attr_name=_attr_name

func update_cb(_attr_name, val):
    if _attr_name==attr_name:
        print(_attr_name, val)
        get_node(label_path).text=attr_name+" : "+str(val)

func _ready():
    UiMsg.connect("on_attribute_change", self, "update_cb")

func _on_Add_button_up():
    Global.emit_signal("reqeust_add_attrbite", attr_name)
