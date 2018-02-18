extends "res://scripts/Character.gd"

const SHOOT_SCENE = preload('res://scenes/mask.tscn')
onready var cursor = get_node("cursor")
onready var timer = get_node("shoot_timer")
onready var can_shoot = true


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

    if Input.is_action_just_pressed('shoot'):
        if can_shoot:
            shoot(joy)
            can_shoot = false
            restart_timer()
        
func shoot(joy):
    var shoot = SHOOT_SCENE.instance()
    get_parent().add_child(shoot)
    shoot.position = get_node('cursor/Position2D').get_global_position()
    shoot.speed_x = joy.x
    shoot.speed_y = joy.y
        
func restart_timer():
    timer.start()
    
func _on_shoot_timer_timeout():
    can_shoot = true
