extends CharacterBody2D
class_name Mob

signal mob_death(position: Vector2, rotation: float)

var speed = 100.0

var target_position = Vector2.ZERO

var mob_spawn_location = Vector2.ZERO

var target = null


func init_mob(spawn_location: PathFollow2D, mob_target: CharacterBody2D) -> void:
	mob_spawn_location = spawn_location
	mob_spawn_location.progress_ratio = randf()

	position = mob_spawn_location.position

	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	rotation = direction

	velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	velocity = velocity.rotated(direction)

	target = mob_target


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])


func _physics_process(_delta) -> void:
	var new_target_position = Vector2.ZERO
	if target != null:
		new_target_position = target.global_position

	target_position = new_target_position
	var direction = (target_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()


func take_damage() -> void:
	emit_signal("mob_death", position, rotation)
	queue_free()