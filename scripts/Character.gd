extends Area2D

onready var sprite = get_node("sprite")
onready var tween = get_node("tween")

export var speed = 4

var tile_size = 64
var can_move = true
var facing = 'right'
var moves = {'right': Vector2(1, 0),
             'left': Vector2(-1, 0),
             'up': Vector2(0, -1),
             'down': Vector2(0, 1)}
var vel = Vector2()
var raycasts = {'right': 'RayCastRight',
                'left': 'RayCastLeft',
                'up': 'RayCastUp',
                'down': 'RayCastDown'}


 
func move(dir):
    var input = Vector2(0, 0)
    facing = dir
    if get_node(raycasts[facing]).is_colliding() or get_node(raycasts[facing]+'2').is_colliding():
        return
    input = moves[dir]
    vel = input.normalized() * speed
    sprite.play(facing) 
    position = position + vel

#func go_idle():
#    sprite.play('idle')
    

func _on_tween_tween_completed( object, key ):
    can_move = true
