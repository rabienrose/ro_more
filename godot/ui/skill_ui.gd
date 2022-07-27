extends Node2D

export (Resource) var skill_item_res
export (NodePath) var skill_list_path

func on_add_skill(skill_name, info):
    var skill_obj = skill_item_res.instance()
    skill_obj.on_create(skill_name,info)
    get_node(skill_list_path).add_child(skill_obj)

func toggle_window():
    visible=!visible

func _ready():
    UiMsg.connect("show_skill_ui", self, "toggle_window")
    UiMsg.connect("add_skill", self, "on_add_skill")

