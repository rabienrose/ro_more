extends Node

class_name ConfigTools

static func generate_exp_table():
    var b_base=false
    var exp_coef=1.1
    var init_exp=50
    var max_lv=50
    var config_file=Global.config_root+"base_exp.json"
    if b_base==false:
        config_file=Global.config_root+"job_exp.json"
    var exp_table=[]
    exp_table.resize(max_lv)
    for i in range(max_lv):
        exp_table[i]=[i,int(init_exp*pow(exp_coef,i))]
    var f=File.new()
    f.open(config_file, File.WRITE)
    print(exp_table)
    f.store_string(JSON.print(exp_table))
    f.close()

