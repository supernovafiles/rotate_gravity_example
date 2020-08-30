extends Node2D

onready var hero = preload("res://scenes/hero.tscn")
onready var sceneNode = $Scene
onready var stageNode = $Scene/Stage
onready var positionNode = $Scene/Stage/Position

var heroNode

func _ready():
	heroNode = hero.instance()
	stageNode.add_child(heroNode)
	heroNode.position = positionNode.position
