extends Area2D

onready var player = get_node("../../Player")

var speed = 50
var nav = null setget set_nav
var path = []
var goal = Vector2()

func _ready():
    pass

func set_nav(new_nav):
    nav = new_nav
    update_path()


func update_path():
    goal = player.position
    path = nav.get_simple_path(position, goal, false)
    if path.size() == 0:
        queue_free()

func _physics_process(delta):
    if path.size() > 1:
        var d = position.distance_to(path[0])
        if d > 2:
            position = position.linear_interpolate(path[0], speed*delta)
        else:
            path.remove(0)
    else:
        update_path()

