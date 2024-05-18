extends Area2D

@export var speed = 500

var direction = Vector2.ZERO
var start_position = Vector2.ZERO
const MAX_DISTANCE = 500


func init_bullet(player: CharacterBody2D, target: Vector2, attack_sound: AudioStreamPlayer) -> void:
	position = player.position
	start_position = position
	direction = (target - player.position).normalized()
	look_at(target)
	attack_sound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var offset = direction * speed * delta
	position += offset
	if start_position.distance_to(position) >= MAX_DISTANCE:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("mobs"):
		body.take_damage()

	queue_free()
