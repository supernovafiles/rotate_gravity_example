extends Node2D

onready var stage = $Stage

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("rotate_left"):
		rotate_stage(-90)
	if Input.is_action_just_pressed("rotate_right"):
		rotate_stage(90)
	print("p: ",position)

func rotate_stage(degrees):
	SIGN.emit_signal("rotationStarted",degrees)
	set_process(false)
	var rotationTween = Tween.new()
	rotationTween.interpolate_property(
		self,
		"rotation_degrees",
		rotation_degrees,
		rotation_degrees + degrees,
		1,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT)
	add_child(rotationTween)
	rotationTween.start()
	yield(rotationTween, "tween_completed")
	SIGN.emit_signal("rotationFinished")
	set_process(true)
