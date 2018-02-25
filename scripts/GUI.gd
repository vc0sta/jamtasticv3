extends MarginContainer

onready var global = get_node("/root/global")

func show_alert(which):
    $container/alerta.visible = (which == 1)
    $container/cuidado.visible = (which == 2)

func _process(delta):
    var start = global.levels[global.current].start_stamp
    var ticks = OS.get_ticks_msec() - start
    $timer.text = global.string_from_time(ticks)
