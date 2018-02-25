extends Node

class LevelData:
    var scene = ''
    var star_time = 0
    var start_stamp = 0
    var time = 0
    var stars = 3
    var was_seen = false
    
    func _init(scene, star_time):
        self.scene = scene
        self.star_time = star_time
    

var current_scene = null

var levels = []
var current = 0
var is_level_scene = false

func _ready():
    var root = get_tree().get_root()
    current_scene = root.get_child( root.get_child_count() -1 )
    
    levels.append( LevelData.new( 'res://scenes/level_01.tscn', 6000 ) )
    levels.append( LevelData.new( 'res://scenes/level_02.tscn', 12000 ) )
    levels.append( LevelData.new( 'res://scenes/level_03.tscn', 12000 ) )
        
        
func goto_scene(path):

    # This function will usually be called from a signal callback,
    # or some other function from the running scene.
    # Deleting the current scene at this point might be
    # a bad idea, because it may be inside of a callback or function of it.
    # The worst case will be a crash or unexpected behavior.

    # The way around this is deferring the load to a later time, when
    # it is ensured that no code from the current scene is running:

    call_deferred("_deferred_goto_scene",path)

func show_stats():
    levels[current].time = OS.get_ticks_msec() - levels[current].start_stamp
    is_level_scene = false
    goto_scene("res://scenes/stats_screen.tscn")
    
func start_game():
    is_level_scene = true
    goto_scene(levels[0].scene)
        
func next_level():
    current += 1
    if current == levels.size():
        current = 0
        is_level_scene = false
        goto_scene("res://MainMenu.tscn")
    else:
        is_level_scene = true
        goto_scene(levels[current].scene)

func _deferred_goto_scene(path):

    # Immediately free the current scene,
    # there is no risk here.
    current_scene.free()

    # Load new scene
    var s = ResourceLoader.load(path)

    # Instance the new scene
    current_scene = s.instance()

    if is_level_scene:
        levels[current].start_stamp = OS.get_ticks_msec()
    # Add it to the active scene, as child of root
    get_tree().get_root().add_child(current_scene)

    # optional, to make it compatible with the SceneTree.change_scene() API
    get_tree().set_current_scene( current_scene )
    
func string_from_time(ticks):
    var secs = ticks / 1000
    var mins = secs / 60
    secs = secs % 60
    var millis = ticks % 1000
    return "%02d:%02d.%03d" % [ mins, secs, millis ]
    
func spotted_player():
    levels[current].was_seen = true

func get_score():
    return levels[current]
    