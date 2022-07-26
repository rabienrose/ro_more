extends Control

export (Resource) var item_res
export (NodePath) var list_path

var list_node

func add_item(attr_name):
    var item_obj = item_res.instance()
    list_node.add_child(item_obj)
    item_obj.set_attr_name(attr_name)

func show_attr():
    visible=!visible

func _ready():
    list_node=get_node(list_path)
    add_item("str")
    add_item("agi")
    add_item("dex")
    add_item("vit")
    add_item("int")
    add_item("luk")
    UiMsg.connect("show_attribute_ui",self, "show_attr")
    
    

