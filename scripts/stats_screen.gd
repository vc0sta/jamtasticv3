extends Node

onready var global = get_node("/root/global")

var stars_out = []
var stars_fill = []

func _ready():
    stars_out.append( $stars/star0_out )
    stars_out.append( $stars/star1_out )
    stars_out.append( $stars/star2_out )
    stars_fill.append( $stars/star0_fill )
    stars_fill.append( $stars/star1_fill )
    stars_fill.append( $stars/star2_fill )
    
    var stars = 3;
    
    var score = global.get_score()
    var time = score.time
    
    if score.was_seen:
        stars -= 1
        
    if time > score.star_time:
        stars -= 1
        
    $label.text = "Tempo: %s" % global.string_from_time(time)
    show_stars(stars)
    

func show_stars(stars_count):
    if stars_count > 3:
        stars_count = 3
        
    for i in range(0, stars_out.size()):
        if( stars_count > i ):
            stars_out[i].visible = false
            stars_fill[i].visible = true
        else:
            stars_out[i].visible = true
            stars_fill[i].visible = false
            
func _input(event):
    if Input.is_action_just_pressed('interact') && !event.is_echo():
        global.next_level()

            
