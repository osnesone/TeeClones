extends Spatial

var tee_scene = preload("res://src/scenes/Tee.tscn")
var teeIn
var base_pos: Vector3
var id: int = 0

func _ready():
	base_pos = $Position3D.global_transform.origin
	
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

func _process(_dt):
	if Input.is_action_just_pressed("buy"):
		if !Globals.is_buying:
			Globals.is_buying = true
			Globals.suspend_mouse = true
			$BuyMenu.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Globals.is_buying = false
			Globals.suspend_mouse = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$BuyMenu.hide()
	$BuyMenu/CenterContainer/VBoxContainer/Currency.text = "$" + str(Globals.currency)
