extends CharacterBody2D
class_name Mob

var speed = 100.0
var target_position = Vector2.ZERO

var player = null

signal mob_death(position: Vector2, rotation: float)

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

func _physics_process(_delta):
	var new_target_position = Vector2.ZERO
	if player != null:
		new_target_position = player.global_position

	target_position = new_target_position
	var direction = (target_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func set_target(new_player):
	player = new_player

func _on_visible_on_screen_notifier_2d_screen_exited():
	pass
	# queue_free()


func take_damage():
	emit_signal("mob_death", position, rotation)
	queue_free()