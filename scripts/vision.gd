extends Light2D

onready var raycast = get_node('RayCast2D')
var can_spot = false

func _ready():
    pass

func _process(delta):
    if can_spot:
        if raycast.get_collider().name == 'Player':
            print ('ALERTA!')
            color = Color(1.0,0,0,1)
    
    
func _on_vision_range_area_entered( area ):
    if area.name == 'Player':
        can_spot = true

func _on_vision_range_area_exited( area ):
    if area.name == 'Player':
        print ('exited_area')
        can_spot = false
        color = Color(0.2,0.8,1,1)
