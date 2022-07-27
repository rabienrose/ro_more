extends Control

var skill_name=""

export (NodePath) var btn_path

func on_create(_skill_name, info):
    skill_name=_skill_name
    get_node(btn_path).text=info["title"]

func _ready():
    pass

func _on_Button_button_up():
    UiMsg.emit_signal("request_use_skill",skill_name)
