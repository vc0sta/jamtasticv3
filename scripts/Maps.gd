extends Node

signal map_update
var mob = preload("res://scenes/mob.tscn")

onready var end_pos
onready var map = get_node("nav/map")
onready var nav = get_node("nav")

onready var mob_container = get_node("mob_container")

onready var player = get_node("Player")

func map_update():
    print( "map update" )
    emit_signal("map_update")
    if !mob_container:
        return
    
    for enemy in mob_container.get_child_count():
        for index in mob_container.get_child(enemy).get_child_count():
            var m = mob_container.get_child(enemy).get_child(index)
            if 'mob' in m.name:
                m.nav = nav

func _input(event):
    end_pos = get_node("Player").position
    if event is InputEventMouseButton and event.pressed:
        
        var tile = map.world_to_map(event.position + (end_pos - get_viewport().size/2))
        print("pos: %s, end_pos: %s, size: %s, tile: %s" %[event.position, end_pos, get_viewport().size, tile] )
        if event.button_index == 1:
            map.set_cell(tile.x, tile.y, 1)
        elif event.button_index == 2:
            map.set_cell(tile.x, tile.y, 0)
    if event is InputEventMouseButton and not event.pressed:
        map_update()


func _on_map_settings_changed():
    map_update()
