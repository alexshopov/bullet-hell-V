extends CharacterBody2D
class_name Mob

signal mob_death(position: Vector2, rotation: float)

var speed = 100.0

var target_position = Vector2.ZERO

var mob_spawn_location = Vector2.ZERO

var target: CharacterBody2D = null

@onready var nav_agent: NavigationAgent2D = $NavAgent

func init_mob(spawn_location: PathFollow2D, mob_target: CharacterBody2D) -> void:
	mob_spawn_location = spawn_location
	mob_spawn_location.progress_ratio = randf()

	position = mob_spawn_location.position

	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	# rotation = direction

	velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	velocity = velocity.rotated(direction)

	target = mob_target


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("walk")


func _physics_process(_delta) -> void:
	if target == null:
		return

	var direction = global_position.direction_to(nav_agent.get_next_path_position())
	velocity = direction * speed
	move_and_slide()


func take_damage() -> void:
	emit_signal("mob_death", position, rotation)
	queue_free()


func _on_nav_timer_timeout():
	if target == null:
		return
	nav_agent.target_position = target.global_position

