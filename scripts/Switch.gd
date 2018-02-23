extends Node


export (bool) var on setget _set_state
export(NodePath) var tile_map
export (Array, Vector2) var tiles

var tex_on = preload('res://arte/map/switch-on.png')
var tex_off = preload('res://arte/map/switch-off.png')
var original_values = []

onready var sprite = get_node('sprite')
onready var button = get_node('button')

var map


func _update_texture():
    if sprite:
        sprite.set_texture( tex_on if on else tex_off )

func _ready():
    map = get_node(tile_map)
    for tile in tiles:
        var orig = map.get_cellv( tile )
        original_values.append( orig )
    _update_texture()

func toggle():
    self.on = !on  #using self to trigger the setter
    for i in range(0, tiles.size() ):
        map.set_cellv( tiles[i],  0 if on else original_values[i] )
    map.emit_signal("settings_changed")

func _input(event):
    if Input.is_action_just_pressed('interact') and button.visible:
        toggle()
    
    
func _set_state(new_state):
    on = new_state
    _update_texture()
    
    
func _on_Switch_area_entered( area ):
    button.visible = true


func _on_Switch_area_exited( area ):
    button.visible = false
