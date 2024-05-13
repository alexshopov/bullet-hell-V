extends Area2D

@export var speed = 500

var direction = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body:Node):
	if body.is_in_group("mobs"):
		body.take_damage()

	queue_free()
