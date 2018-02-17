extends "res://scripts/Character.gd"

onready var cursor = get_node("cursor")
signal pos_update

func _process(delta):
    for dir in moves.keys():
        if Input.is_action_pressed(dir):
            move(dir)

    var joy = Vector2(Input.get_joy_axis(0,2),-Input.get_joy_axis(0,3))

    if joy.x > -0.2 and joy.x < 0.2 and joy.y > -0.2 and joy.y < 0.2:
        cursor.visible = false
    else:
        cursor.visible = true
    cursor.rotation_degrees = rad2deg(atan2(joy.x, joy.y))

