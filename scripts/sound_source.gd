extends Area2D

onready var button = get_node("interact_button")
onready var audio = get_node("audio")
onready var sprite_on = get_node("Sprite2")
onready var timer = get_node("Timer")


func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    pass

        
func _input(event):
    if Input.is_action_just_pressed('interact') and button.visible:

        sprite_on.visible = false
#=======
#        get_node("/root/global").show_stats()
#>>>>>>> 534730893dcff561bb35c94d494908182e120dee
        audio.playing = false
        timer.start()
        
        



func _on_Player_can_interact():
    button.visible = true


func _on_Player_cannot_interact():
    button.visible = false


func _on_Timer_timeout():
    get_node("/root/global").next_level()
