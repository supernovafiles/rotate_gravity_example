extends KinematicBody2D

const GRAVITY = 200
var velocity = Vector2()

func _ready():
	SIGN.connect("rotationStarted" , self , "on_rotation_started")
	SIGN.connect("rotationFinished" , self , "on_rotation_finished")

func _physics_process(delta):
	velocity.y += delta * GRAVITY

	var a = move_and_slide(velocity,Vector2(0,-1))
	if a.y == 0:
		velocity.y = 0
	
	print("a: ",a)
	print("v: ",velocity)

func on_rotation_started(degrees):
	rotation_degrees = rotation_degrees -degrees
	set_physics_process(false)

func on_rotation_finished():
	set_physics_process(true)
