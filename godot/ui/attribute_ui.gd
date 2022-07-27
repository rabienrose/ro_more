extends Control

export (Resource) var item_res
export (NodePath) var s_point_label_path

func show_attr():
    visible=!visible

func on_attr_point_change(val):
    get_node(s_point_label_path).text="Point: "+str(val)

func _ready():
    UiMsg.connect("show_attribute_ui",self, "show_attr")
    UiMsg.connect("attr_point_change",self, "on_attr_point_change")
