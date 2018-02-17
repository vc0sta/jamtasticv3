extends Node

signal map_update
var mob = preload("res://scenes/mob.tscn")

onready var start_pos = get_node("start_pos").position
onready var end_pos
onready var nav = get_node("nav")
onready var map = get_node("nav/map")

onready var mob_container = get_node("mob_container")

onready var player = get_node("Player")

func _ready():
    var m = mob.instance()
    mob_container.add_child(m)
    m.position = start_pos
    m.goal = player.position
    m.nav = nav
    connect('map_update', m, 'update_path')

func _input(event):
    end_pos = get_node("Player").position
    if event is InputEventMouseButton and event.pressed:
        print(event.position + (end_pos - get_viewport().size/2) , end_pos)
        var tile = map.world_to_map(event.position + (end_pos - get_viewport().size/2))
        if event.button_index == 1:
            map.set_cell(tile.x, tile.y, 1)
        elif event.button_index == 2:
            map.set_cell(tile.x, tile.y, 0)
    if event is InputEventMouseButton and not event.pressed:
        emit_signal("map_update")


