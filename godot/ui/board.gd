extends VBoxContainer

export (NodePath) var hp_bar_path
export (NodePath) var sp_bar_path
export (NodePath) var name_label_path

var hp_bar
var sp_bar
var name_label

func _ready():
    hp_bar=get_node(hp_bar_path)
    sp_bar=get_node(sp_bar_path)
    name_label=get_node(name_label_path)

func update_up(hp, max_hp):
    hp_bar.text="hp:"+str(hp)+"/"+str(max_hp)
    
func update_name(unit_name):
    name_label.text=unit_name

func update_sp(sp, max_sp):
    sp_bar.text="sp:"+str(sp)+"/"+str(max_sp)
