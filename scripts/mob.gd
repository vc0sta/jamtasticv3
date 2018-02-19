extends Area2D

export(NodePath) var patrol_start_path
export(NodePath) var patrol_end_path
export(NodePath) var player_path
export(NodePath) var nav_path

onready var player = get_node(player_path)
onready var vision = get_node('vision/vision_range')
onready var vision_light = get_node('vision')
onready var vision_raycast = get_node('vision/RayCast2D')
onready var effect = get_node("vision_effect")

onready var patrol_start = get_node(patrol_start_path)
onready var patrol_end = get_node(patrol_end_path)
onready var nav = get_node(nav_path) setget set_nav


var speed = 50
var path = []
var last_point
var goal = Vector2()
var alert = false

func _ready():
    goal = patrol_end.position
    pass
    

func set_nav(new_nav):
    nav = new_nav
    print(nav)
    update_path()
#
#func _draw():
#    for p in path:
#        if p == path[0]:
#          last_point = p 
#        elif path[path.size()-1] == p:
#            pass
#        else:
#            draw_line(last_point-position, p-position, Color(255, 0, 0), 1)
#            last_point = p

func update_path():
    goal = patrol_end.position
    path = nav.get_simple_path(position, goal, false)
    if path.size() == 0:
        queue_free()

func _physics_process(delta):
    
    if position.distance_to(patrol_end.position) < 80:
        patrol_end.position = patrol_start.position
        patrol_start.position = goal
        
    if path.size() > 1:
        var d = position.distance_to(path[0])
        if d > 2:
            position = position.linear_interpolate(path[0], speed*delta)
        else:
            path.remove(0)
    else:
        update_path()
       
    
    vision_raycast.rotation_degrees = rad2deg((player.position - position).angle())-vision_light.rotation_degrees - 90 
    
           
    if path.size() > 1:
        var side = path[1] - path[0]
        var final_angle = rad2deg(side.angle())-90
        var initial_angle = vision_light.rotation_degrees
        
        if initial_angle < -180 and final_angle > 0:
            initial_angle += 360
        elif initial_angle > 0 and final_angle < -180:
            initial_angle -= 360
             
        effect.interpolate_property(vision_light, 'rotation_degrees',
            initial_angle, final_angle, 0.3,
            Tween.TRANS_LINEAR, Tween.EASE_OUT)
        
        effect.start()
            
    update()
