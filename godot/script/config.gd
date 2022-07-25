extends Node

var job_info={}

func read_a_json(file_name):
    var f= File.new()
    f.open(file_name, File.READ)
    var text = f.get_as_text()
    
    var re_json = JSON.parse(text)
    return re_json.result

func _ready():
    job_info = read_a_json("res://config/job_info.json")
    print(job_info)

