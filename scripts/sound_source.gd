extends Area2D

onready var button = get_node("interact_button")
onready var audio = get_node("audio")


func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    pass

        
func _input(event):
    if Input.is_action_just_pressed('interact') and button.visible:
        get_node("/root/global").show_stats()
        audio.playing = false



func _on_Player_can_interact():
    button.visible = true


func _on_Player_cannot_interact():
    button.visible = false
