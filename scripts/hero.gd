extends KinematicBody2D

onready var animSprite = $AnimatedSprite

enum {
	IDLE,
	WALKING,
	JUMPING,
	FALLING,
	LANDING
	}

var state = IDLE
var history = []
var movement
var dir
var rotationResult = 0

const GRAVITY_SPEED = 200
const WALK_SPEED = 100

var jumpSpeed = 100
var velocity = Vector2()

func _ready():
	SIGN.connect("rotationStarted" , self, "on_rotation_started")
	SIGN.connect("rotationFinished" , self , "on_rotation_finished")

func _physics_process(delta):
	match state:
		IDLE:
			velocity.x = 0
			animSprite.animation = "idle"
		JUMPING:
			jump()
		WALKING:
			walk(dir)
		FALLING:
			animSprite.animation = "falling"
			if Input.is_action_pressed("ui_right"):
				velocity.x = WALK_SPEED
				animSprite.flip_h = false
			elif Input.is_action_pressed("ui_left"):
				velocity.x = -WALK_SPEED
				animSprite.flip_h = true
			else:
				velocity.x = 0
		LANDING:
			velocity.x = 0
			animSprite.animation = "landing"
			yield(animSprite,"animation_finished")
			state = IDLE
		_:
			state = IDLE

	velocity.y += delta * GRAVITY_SPEED
	movement = move_and_slide(velocity,Vector2(0,-1))
	if movement.y == 0:
		velocity.y = 0
	print("m: ",movement)
	print("x: ",velocity.x)
	print("y: ",velocity.y)
	print("s: ", state)
	print(is_on_floor())

	if movement.y > 0 and is_on_floor() == false:
		state = FALLING
	elif movement.y == 0 and state == FALLING and is_on_floor():
		state = LANDING

func _input(event):
	if state == WALKING:
		if event.is_action_pressed("ui_up") and is_on_floor():
			state = JUMPING
		if event.is_action_released("ui_right") and is_on_floor():
			state = IDLE
		if event.is_action_released("ui_left") and is_on_floor():
			state = IDLE

	if state == IDLE:
		if event.is_action_pressed("ui_right") and is_on_floor():
			state = WALKING
			dir = "right"
		if event.is_action_pressed("ui_left") and is_on_floor():
			state = WALKING
			dir = "left"
		if event.is_action_pressed("ui_up") and is_on_floor():
			state = JUMPING

	if state == JUMPING:
		if event.is_action_pressed("ui_right") and is_on_floor():
			state = WALKING
			dir = "right"
		if event.is_action_pressed("ui_left") and is_on_floor():
			state = WALKING
			dir = "left"

func jump():
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		animSprite.animation = "anticipation"
		yield(animSprite,"animation_finished")
		velocity.y = -jumpSpeed
		animSprite.animation = "jumping"
		yield(animSprite,"animation_finished")
		animSprite.animation = "in_air"
	if Input.is_action_pressed("ui_right"):
		velocity.x = WALK_SPEED
		animSprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
		animSprite.flip_h = true
	else:
		velocity.x = 0

func walk(direction):
	match direction:
		"right":
			velocity.x = WALK_SPEED
			animSprite.flip_h = false
			animSprite.animation = "walking"
		"left":
			velocity.x = -WALK_SPEED
			animSprite.flip_h = true
			animSprite.animation = "walking"

func on_rotation_started(degrees):
	var rotationTween = Tween.new()
	rotationTween.interpolate_property(
		self,
		"rotation_degrees",
		rotation_degrees,
		rotation_degrees -degrees,
		1,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	add_child(rotationTween)
	rotationTween.start()
	rotation_degrees = rotation_degrees -degrees
	set_physics_process(false)
	
func on_rotation_finished():
	set_physics_process(true)
