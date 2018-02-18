extends Area2D

const SHOOT_SPEED = 500
var speed_x = 1
var speed_y = 0

func _ready():    
    pass
    

func _process(delta):
    var motion = Vector2(speed_x, -speed_y).normalized() * SHOOT_SPEED
    position = position + motion * delta
    

    
    
    

func _on_VisibilityNotifier2D_screen_exited():
    queue_free()


func _on_mask_area_entered( area ):
    if area.name != 'Player':
        queue_free()
    
