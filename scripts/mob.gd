extends Area2D

export(NodePath) var patrol_start_path
export(NodePath) var patrol_mid_path
export(NodePath) var patrol_end_path
export(NodePath) var player_path
export(NodePath) var nav_path
export(NodePath) var GUI_path

onready var patrol_start = get_node(patrol_start_path)
onready var patrol_mid = get_node(patrol_mid_path)
onready var patrol_end = get_node(patrol_end_path)
onready var nav = get_node(nav_path) setget set_nav

onready var map = get_node('../../../Switch')
onready var player = get_node(player_path)
onready var vision = get_node('vision/vision_range')
onready var vision_light = get_node('vision')
onready var vision_raycast = get_node('vision/RayCast2D')
onready var effect = get_node("vision_effect")
onready var path_timer = get_node('path_timer')
onready var alert_timer = get_node('alert_timer')
onready var warning_timer = get_node('warning_timer')
onready var GUI = get_node(GUI_path)


var alert_vel = 4
var speed = 500
var path = []
var last_point
var goal = Vector2()
var alert = false setget set_alert
var is_visible = false
var needs_update = true

var last_print = ''

func _ready():
    self.modulate = Color(1, 1, 1, 0)
    goal = patrol_mid.position
    pass

func set_alert(new_alert):
    alert_vel = 1
    alert = new_alert
    update_path()
    
func set_nav(new_nav):
    print( "set_nav %s" % nav )
    nav = new_nav
    needs_update = true

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
#    goal = patrol_mid.position
    if alert:
        path = nav.get_simple_path(position, player.position, false)
        path_timer.start()
    else:
        path = nav.get_simple_path(position, goal, false)
#    if path.size() == 0:
#        queue_free()
    needs_update = false

func restart_timer():
    path_timer.start()
        
func fade_visibilty(in_out):
    var from = 0
    var to = 1
    if in_out == 1:
        is_visible = true
    else:
        is_visible = false
        from = 1
        to = 0
        
    effect.interpolate_property(vision_light, 'energy', from, to, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
    effect.interpolate_property(self, "modulate", 
            Color(1, 1, 1, from), Color(1, 1, 1, to), 0.1, 
            Tween.TRANS_LINEAR, Tween.EASE_IN)
            
            
func _process(delta):
    if needs_update:
        update_path()

    if position.distance_to(goal) < 100:
        patrol_mid.position = patrol_end.position
        patrol_end.position = patrol_start.position
        patrol_start.position = goal
        goal = patrol_mid.position
        

        
    if path.size() > 1:
        
        var d = position.distance_to(path[0])
        if d > 20:
            position = position.linear_interpolate(path[0], speed*delta/alert_vel)
        else:
            path.remove(0)
    else:
        update_path()
       
    vision_raycast.rotation_degrees = rad2deg((player.position - position).angle())-vision_light.rotation_degrees - 90 
    
    
    if vision_raycast.is_colliding():
#        if vision_raycast.get_collider().name != last_print:
#            last_print = vision_raycast.get_collider().name
            
        if vision_raycast.get_collider().name == 'Player':
            if is_visible == false:
                fade_visibilty(1)
        elif is_visible == true:
            fade_visibilty(0)
    
        
    if path.size() > 1:
        var side = path[1] - path[0]
        var final_angle = rad2deg(side.angle())-90
        var initial_angle = vision_light.rotation_degrees
        
        if initial_angle < -180 and final_angle > 0:
            initial_angle += 360
        elif initial_angle > 0 and final_angle < -180:
            initial_angle -= 360
             
        effect.interpolate_property(vision_light, 'rotation_degrees',
            initial_angle, final_angle, 0.5,
            Tween.TRANS_LINEAR, Tween.EASE_OUT)
        
        effect.start()
    update()


func _on_path_timer_timeout():
    update_path()


func _on_alert_timer_timeout():
    print('alert_timer off')
    warning_timer.stop()
    warning_timer.wait_time = 3
    warning_timer.start()
    GUI.get_child(0).get_child(0).visible = false
    GUI.get_child(0).get_child(1).visible = true
    alert = false
    alert_vel = 4


func _on_vision_GUI_change():
    map.close()
    GUI.get_child(0).get_child(1).visible = false
    GUI.get_child(0).get_child(0).visible = true


func _on_warning_timer_timeout():
    map.open()
    GUI.get_child(0).get_child(1).visible = false


func _on_map_settings_changed():
    pass # replace with function body
