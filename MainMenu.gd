extends MarginContainer

var last_index = 0

var tex_como_jogar = preload('res://menu/como_jogar.png')
var tex_novo_jogo = preload('res://menu/novo_jogo.png')
var tex_sair = preload('res://menu/sair.png')
var sel_como_jogar = preload('res://menu/como_jogar_selected.png')
var sel_novo_jogo = preload('res://menu/novo_jogo_selected.png')
var sel_sair = preload('res://menu/sair_selected.png')

onready var effect = get_node("transitions")

# member variables here, example:
# var a=2
# var b="textvar"

export var rotation = .1

var index = 0
var menu_buttons = ['como_jogar','novo_jogo','sair']
var selected = [sel_como_jogar, sel_novo_jogo, sel_sair]
var texture = [tex_como_jogar, tex_novo_jogo, tex_sair]

func _ready():
    get_node('HBoxContainer/VBoxContainer/CenterContainer/VBoxContainer/' + menu_buttons[0]).texture = selected[0]
    
    #Set window title
    OS.set_window_title("DEIXE O SAMBA MORRER [Jamtastic vol.3]")
    #Hide mouse.
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

    
        
func _input(event):
    if event.is_action("ui_up") && event.is_pressed() && !event.is_echo():
        index = index - 1
    if event.is_action("ui_down") && event.is_pressed() && !event.is_echo():
        index = index + 1
        
    index = abs(index%3)
    
    if last_index != index:
        get_node('HBoxContainer/VBoxContainer/CenterContainer/VBoxContainer/' + menu_buttons[index]).texture = selected[index]
        get_node('HBoxContainer/VBoxContainer/CenterContainer/VBoxContainer/' + menu_buttons[last_index]).texture = texture[last_index]
        last_index = index
        
    if event.is_action("ui_accept") && event.is_pressed() && !event.is_echo():
        if (index == 0):
            print("Como jogar")
        if (index == 1):
            get_node("/root/global").goto_scene("res://scenes/level_03.tscn")
        if(index == 2):
            get_tree().quit()