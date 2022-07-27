extends Node2D

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_path="res://game.db"
var maps_root
var map_list=["map2"]
var map_objs={}

func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        db.close_db()

func save_char_info(char_name, info):
    db.update_rows("char", "name = '"+ char_name +"'", info)

func get_char_info(char_name):
    var re_data = db.select_rows("char", "name == '"+char_name+"'", ["*"])
    return re_data[0]

func get_char_skills(char_id):
    var re_data = db.select_rows("skill", "char_id == "+str(char_id), ["*"])
    return re_data

func _ready():
    var char_name="chamo"
    maps_root=get_node("Maps")
    db = SQLite.new()
    db.path=db_path
    db.open_db()
    for map_name in map_list:
        var map_path = Global.map_path+map_name+".tscn"
        var map_res=load(map_path)
        var map_node = map_res.instance()
        maps_root.add_child(map_node)
        map_node.on_create(self)
        map_objs[map_name]=map_node
    var re_data = db.select_rows("char", "name == '"+char_name+"'", ["map"])
    map_objs[re_data[0]["map"]].char_join(char_name)

func _on_AttrTab_button_down():
    UiMsg.emit_signal("show_attribute_ui")


func _on_SkillTab_button_down():
    UiMsg.emit_signal("show_skill_ui")
