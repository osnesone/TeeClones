extends Spatial

var mouse_sens = 0.005

var jumps: int = 0
var vel = Vector3()
var inps: Array = []
var inpi: int = 0
var is_clone = false
var current_camera = false
var id: int

onready var head: Spatial = $KinematicBody/Head
onready var kinb: KinematicBody = $KinematicBody
onready var ray: RayCast = $KinematicBody/Head/Camera/Cursor/RayCast
onready var lab = $CenterContainer/VBoxContainer/DistanceLabel
var hook = preload("res://src/scenes/Hook.tscn")

enum {
	NOT_PRESSED,
	JUST_PRESSED,
	PRESSED,
	JUST_RELEASED,
}

class teeinput:
	var hordir = Vector2()
	var camrot = Vector2()
	var hookst: int = 0
	var jumpst: int = 0

func _ready():
	if current_camera:
		$KinematicBody/Head/Camera.make_current()

	if is_clone:
		$CenterContainer/VBoxContainer/DistanceLabel.visible = false
		$CenterContainer/VBoxContainer/Label.visible = true
		$KinematicBody/MeshInstance.visible = true

func _physics_process(dt):
	var snap_vector = Vector3()
#	var input_move = Vector3()
	var acc = Vector3()
	var nvel = Vector3()
	var hvel = Vector2()
	var inp = get_input()
	nvel = vel

	if not kinb.is_on_floor():
		acc += WorldParams.GRAVITY_ACC * Vector3.DOWN
		nvel += apply_friction(vel, WorldParams.AFRICT * dt)
	else:
		nvel += apply_friction(vel, WorldParams.GFRICT * dt)
		snap_vector = -kinb.get_floor_normal()
		jumps = 0

#	input_move = get_input_direction()
	var hordir = Vector3(inp.hordir.x, 0, inp.hordir.y)
	nvel += apply_accel(vel, hordir, WorldParams.MOVE_ACC * dt, \
		WorldParams.MAX_MOVE_VEL)

#	if Input.is_action_just_pressed("jump") and jumps < WorldParams.MAX_JUMPS:
	if inp.jumpst == JUST_PRESSED and jumps < WorldParams.MAX_JUMPS:
		snap_vector = Vector3.ZERO
		nvel.y = WorldParams.JUMP_VEL
		jumps += 1

	if has_node("Hook") and $Hook.collided:
		var dp = $Hook.global_transform.origin - \
			kinb.global_transform.origin
		acc += hook_acc(dp)

	nvel += acc * dt

	hvel = Vector2(nvel.x, nvel.z)
	if hvel.length_squared() >= WorldParams.MAX_VEL * WorldParams.MAX_VEL:
		hvel = hvel.normalized() * WorldParams.MAX_VEL
	nvel = Vector3(hvel.x, nvel.y, hvel.y)

#	if Input.is_action_just_pressed("hook"):
	if inp.hookst == JUST_PRESSED:
		rel_h()
		var hi = hook.instance()
		add_child(hi)
#		var rx = head.rotation.x
		var rx = inp.camrot.x
#		var ry = kinb.rotation.y
		var ry = inp.camrot.y
		var hdir = Vector3(sin(ry)*cos(rx), -sin(rx), cos(ry) * cos(rx))
		$Hook.global_transform.origin = \
			kinb.global_transform.origin + hdir * WorldParams.HOOKDIS
		$Hook.rotation = hdir
		$Hook.vel = hdir * WorldParams.HOOKV
#	if Input.is_action_just_released("hook"):
	elif inp.hookst == JUST_RELEASED:
		rtrv_h()
	elif inp.hookst == PRESSED:
		snap_vector = Vector3.ZERO

	nvel = kinb.move_and_slide_with_snap((vel + nvel) / 2, snap_vector, Vector3.UP)
#	nvel = kinb.move_and_slide((vel + nvel) / 2, Vector3.UP)

	vel = nvel
	displaydistance()

func rel_h():
	$KinematicBody/HookLine.visible = false
	if has_node("Hook"):
		$Hook.free()

func rtrv_h():
	if has_node("Hook"):
		$Hook.is_rtrving = true
		$Hook.collided = false

func _input(event):
	if !Globals.suspend_mouse and event is InputEventMouseMotion:
		kinb.rotate_y((-event.relative.x) * mouse_sens)
		head.rotate_x((event.relative.y) * mouse_sens)

func get_input_direction() -> Vector3:
	var z: float = Input.get_action_strength("fwd") - \
		Input.get_action_strength("bwd")
	var x: float = Input.get_action_strength("left") - \
		Input.get_action_strength("right")
	return kinb.transform.basis.xform(Vector3(x, 0, z).normalized())

func apply_friction(v: Vector3, dv: float) -> Vector3:
	return v.normalized() * max(v.length() - dv, 0) - v

func apply_accel(v: Vector3, dir: Vector3, dv: float, maxv: float):
	var p = v.dot(dir)
	if p > maxv:
		return Vector3.ZERO
	return (min(p + dv, maxv) - p) * dir

func hook_acc(dp: Vector3):
#	var dv = dp.normalized() * WorldParams.HACC * min(10, max(1, dp.length_squared() / 10))
	var dv = dp.normalized() * WorldParams.HACC
	if dv.y < 0:
		dv.y *= 0.3
	return dv

func spawn(pos: Vector3):
	inpi = 0
	rel_h()
	self.global_transform.origin = pos
	kinb.global_transform.origin = self.global_transform.origin
	vel = Vector3.ZERO
	kinb.rotation = Vector3.ZERO
	head.rotation = Vector3.ZERO
	
	if is_clone:
		add_to_group("clones")
		tee_visible(true)

func displaydistance():
	var dis = (ray.get_collision_point() - kinb.global_transform.origin).length()
	if dis < WorldParams.MAX_HLEN:
		lab.modulate = Color.green
	else:
		lab.modulate = Color.red
	lab.text = str(dis).pad_decimals(0)

func get_input():
	var inp
	if !is_clone:
		inp = get_player_input()
		save_input(inp)
	else:
		if !(inpi >= inps.size()):
			inp = inps[inpi]
			inpi += 1
		kinb.rotation.y = inp.camrot.y
		head.rotation.x = inp.camrot.x
	return inp

func get_player_input():
	var inp = teeinput.new()
	var hordir = get_input_direction()
	inp.hordir = Vector2(hordir.x, hordir.z)
	inp.camrot = Vector2(head.rotation.x, kinb.rotation.y)

	if !Globals.suspend_mouse:
		if Input.is_action_just_pressed("hook"):
			inp.hookst = JUST_PRESSED
		elif Input.is_action_just_released("hook"):
			inp.hookst = JUST_RELEASED
		elif Input.is_action_pressed("hook"):
			inp.hookst = PRESSED

	if Input.is_action_just_pressed("jump"):
		inp.jumpst = JUST_PRESSED
	else:
		inp.jumpst = NOT_PRESSED
	return inp

func save_input(inp):
	inps.append(inp)

func tee_visible(on: bool):
	$CenterContainer/VBoxContainer/DistanceLabel.visible = false
	$CenterContainer/VBoxContainer/Label.visible = false
	$KinematicBody/MeshInstance.visible = on
	$KinematicBody/Head/EyeL.visible = on
	$KinematicBody/Head/EyeR.visible = on
