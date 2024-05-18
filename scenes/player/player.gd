extends CharacterBody2D

signal shoot_bullet(target: Vector2)

signal hit

@export var speed = 400
@export var max_health = 10

var screen_size
var health
var is_active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	$HealthBar.value = max_health
	show()
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_active:
		$HealthBar.value = health
		handle_player_movement(delta)
		handle_mouse_click()


func _physics_process(delta) -> void:
	var collision = move_and_collide(velocity * delta)

	if collision:
		var collider = collision.get_collider()
		if collider is Mob or collider is Guts:
			take_damage()


# handle player movement
func handle_player_movement(_delta: float):
	velocity = Vector2.ZERO
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
	# 	$AnimatedSprite2D.play()
	# else:
	# 	$AnimatedSprite2D.stop()

	# if velocity.x != 0:
	# 	$AnimatedSprite2D.animation = "walk"
	# 	$AnimatedSprite2D.flip_v = false
	# 	$AnimatedSprite2D.flip_h = velocity.x < 0
	# else:
	# 	$AnimatedSprite2D.animation = "up"
	# 	$AnimatedSprite2D.flip_v = velocity.y > 0


# handle mouse events
func handle_mouse_click() -> void:
	if Input.is_action_just_pressed("left_click"):
		emit_signal("shoot_bullet", get_global_mouse_position())


# reset the player when starting a new game
func start(pos: Vector2) -> void:
	position = pos
	health = max_health
	show()
	$CollisionShape2D.disabled = false


func take_damage() -> void:
	health -= 1
	if health == 0:
		player_death()


func player_death() -> void:
	velocity = Vector2.ZERO
	is_active = false
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)


# called when another body contacts the player
func _on_body_entered(_body: Node2D) -> void:
	take_damage()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("guts"):
		take_damage()
