extends Node

signal show_attribute_ui
signal show_skill_ui
signal show_unit_detail(unit)

signal attribute_change(attr_name, val)
signal reqeust_add_attribute(attr_name)
signal attr_point_change(val)
signal add_skill(skill_name, info)
signal request_use_skill(skill_name)
