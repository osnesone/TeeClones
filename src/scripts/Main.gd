extends Spatial

var tee_scene = preload("res://src/scenes/Tee.tscn")
var teeIn
var base_pos: Vector3
var id: int = 0

func _ready():
	base_pos = $Position3D.global_transform.origin
	
func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if event.scancode == KEY_P:
			for n in get_tree().get_nodes_in_group("player"):
				n.reload_me()

func _on_Play_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$RoundTimer.start()

#	$Camera.clear_current()
	$CenterContainer/Play.visible = false
	init_tee()

func _on_RoundTimer_timeout():
	round_start()

func round_start():
	for ch in get_children():
		if ch.is_in_group("tees"):
			ch.is_clone = true
			ch.spawn(base_pos - 5 * Vector3(ch.id % 3, 0, ch.id / 3))
	init_tee()

func init_tee():
	teeIn = tee_scene.instance()
	teeIn.id = id
	teeIn.transform.origin = \
		(base_pos - 5 * Vector3(teeIn.id % 3, 0, teeIn.id / 3))
	teeIn.current_camera = true
	add_child(teeIn)
	id += 1
