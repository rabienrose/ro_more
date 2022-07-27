extends HBoxContainer

export (NodePath) var label_path

export var attr_name=""

func update_cb(_attr_name, val):
    if _attr_name==attr_name:
        get_node(label_path).text=attr_name+" : "+str(val)

func _ready():
    UiMsg.connect("attribute_change", self, "update_cb")

func _on_Add_button_up():
    UiMsg.emit_signal("reqeust_add_attribute", attr_name)
