extends Node
var job_info={}
var map_info={}
var mob_info={}
var item_info={}
var skill_info={}

var base_exp={}
var job_exp={}
var size_fix={}
var skill_tree={}
var elem_fix={}

func read_items(json_name):
    var items = read_a_json(Global.config_root+json_name+".json")
    for item_id in items:
        item_info[item_id]=items[item_id]

func read_a_json(file_name):
    var f= File.new()
    f.open(file_name, File.READ)
    var text = f.get_as_text()
    var re_json = JSON.parse(text)
    if re_json.error_string!="":
        print(re_json.error_string)
    return re_json.result

func get_attr_point_cost(attr_val):
    return floor(attr_val/10)+3

func _ready():
    job_info = read_a_json(Global.config_root+"job_info.json")
    map_info = read_a_json(Global.config_root+"maps.json")
    mob_info = read_a_json(Global.config_root+"mobs.json")
    read_items("item_card")
    read_items("item_equip")
    read_items("item_etc")
    read_items("item_usable")
    skill_info = read_a_json(Global.config_root+"skills.json")
    base_exp = read_a_json(Global.config_root+"base_exp.json")
    job_exp = read_a_json(Global.config_root+"job_exp.json")
    size_fix = read_a_json(Global.config_root+"size_fix.json")
    skill_tree = read_a_json(Global.config_root+"skill_tree.json")
    elem_fix = read_a_json(Global.config_root+"elem_fix.json")

