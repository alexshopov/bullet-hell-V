class_name BigBoss
extends CharacterBody2D

signal boss_death

@export var mob_guts: PackedScene

@onready var path_follow: PathFollow2D = get_parent()

@export var speed = 75

@export var max_hp = 20
var health = max_hp

func _ready() -> void:
	$AnimatedSprite2D.play()

func _process(delta: float) -> void:
	path_follow.progress += speed * delta
	$HealthBar.value = health

func take_damage():
	health -= 1

	if health == 0:
		emit_signal("boss_death")
		queue_free()
