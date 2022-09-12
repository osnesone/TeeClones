extends KinematicBody

var is_rtrving = false
var vel = Vector3(0,0,0)
var hookorigin = Vector3()
onready var PLRORIGIN = $"../KinematicBody".global_transform.origin
var plrorigin = Vector3()
var collided = false
var colshp = 0

const RSPEED = 30

func _physics_process(dt):
	hookorigin = self.global_transform.origin
	plrorigin = $"../KinematicBody".global_transform.origin
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
		vel = (plrorigin - hookorigin).normalized() * RSPEED

	var col = move_and_collide(vel*dt)

	if col != null:
		collided = true
		colshp = col.get_collider_shape()
		vel = Vector3.ZERO
#		print(colshp)
