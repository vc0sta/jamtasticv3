extends Light2D

onready var raycast = get_node('RayCast2D')


func _ready():
    pass


func _on_vision_range_area_entered( area ):
    if area.name == 'Player':
        print('Raycast to:' + str(rotation_degrees + raycast.rotation_degrees))
        print('Collided with:' + raycast.get_collider().name )
        print ('entered_area')

func _on_vision_range_area_exited( area ):
    if area.name == 'Player':
        print ('exited_area')
