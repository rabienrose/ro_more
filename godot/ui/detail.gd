extends VBoxContainer

export (NodePath) var attr1_path
export (NodePath) var attr2_path
export (NodePath) var attr3_path
export (NodePath) var attr4_path
export (NodePath) var attr5_path
export (NodePath) var attr6_path
export (NodePath) var attr7_path
export (NodePath) var attr8_path

func show_info(unit):
    get_node(attr1_path).text="atk: "+str(unit.atk)
    get_node(attr2_path).text="def: "+str(unit.def)
    get_node(attr3_path).text="flee: "+str(unit.flee)
    get_node(attr4_path).text="hit: "+str(unit.hit)
    get_node(attr5_path).text="atk_spd: "+str(unit.atk_spd)
    get_node(attr6_path).text="cri: "+str(unit.cri)
    get_node(attr7_path).text="blv: "+str(unit.blv)
    get_node(attr8_path).text="baseexp: "+str(unit.baseexp)

func _ready():
    UiMsg.connect("show_unit_detail",self,"show_info")


