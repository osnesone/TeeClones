extends KinematicBody

var is_rtrving = false
var vel = Vector3(0,0,0)
var hookorigin = Vector3()
onready var PLRORIGIN = $"../KinematicBody".global_transform.origin
onready var hook_line = $"../KinematicBody/HookLine"
var plrorigin = Vector3()
var collided = false
var colshp = 0

var dbgi = 0

func _physics_process(dt):
	hookorigin = self.global_transform.origin
	plrorigin = $"../KinematicBody".global_transform.origin
	draw_hook_line()
	if (PLRORIGIN - hookorigin).length_squared() >= \
		WorldParams.MAX_HLEN * WorldParams.MAX_HLEN:
		is_rtrving = true
		PLRORIGIN = plrorigin
	if is_rtrving:
		if (plrorigin - hookorigin).length() <= 0.5:
			self.queue_free()
			return
		self.collision_layer = 0
		self.collision_mask = 0
		vel = (plrorigin - hookorigin).normalized() * WorldParams.RSPEED

	var col = move_and_collide(vel*dt)

	if col != null:
		collided = true
		colshp = col.get_collider_shape()
		vel = Vector3.ZERO
#		print(colshp)
	dbgi += 1

func draw_hook_line():
	hook_line.visible = true
	hook_line.global_transform.origin = (hookorigin + plrorigin) / 2
	hook_line.scale.z = hookorigin.distance_to(plrorigin) / 2
	hook_line.look_at(hookorigin, Vector3.UP)
