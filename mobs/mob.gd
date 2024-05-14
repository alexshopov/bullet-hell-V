extends CharacterBody2D
class_name Mob

var speed = 100.0

signal mob_death(position: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

func _physics_process(delta):
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func take_damage():
	emit_signal("mob_death", position)
	queue_free()