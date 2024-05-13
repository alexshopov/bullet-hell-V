extends Area2D

signal hit

@export var speed = 400
var screen_size

signal shoot_bullet(target: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_player_movement(delta)
	handle_mouse_click()


# handle player movement
func handle_player_movement(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


# handle mouse events
func handle_mouse_click():
	if Input.is_action_just_pressed("left_click"):
		emit_signal("shoot_bullet", get_global_mouse_position())


# called when another body contacts the player
func _on_body_entered(_body:Node2D):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)


# reset the player when starting a new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
