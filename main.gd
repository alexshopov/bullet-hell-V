extends Node

@export var mob_scene: PackedScene

@export var bullet_scene: PackedScene

@export var mob_guts: PackedScene

var score

func game_over():
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


func new_game():
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("guts", "queue_free")
	get_tree().call_group("bullets", "queue_free")

	score = 0
	$Player.start($StartPosition.position)
	$Player.is_active = true
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Prepare yourself")
	$Music.play()
	$NoEscape.play()


func _on_start_timer_timeout():
	$MobTimer.start()

func _on_mob_timer_timeout():
	spawn_mob()

func spawn_mob():
	var mob = mob_scene.instantiate()
	mob.connect("mob_death", _on_mob_death)

	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	var direction = mob_spawn_location.rotation + PI / 2

	mob.position = mob_spawn_location.position

	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.velocity = velocity.rotated(direction)
	mob.set_target($Player)

	add_child(mob)

func _on_player_shoot_bullet(target):
	var bullet = bullet_scene.instantiate()
	bullet.position = $Player.position
	bullet.start_position = bullet.position
	bullet.direction = (target - $Player.position).normalized()
	bullet.look_at(target)
	add_child(bullet)
	$PlayerAttack.play()

func _on_mob_death(position: Vector2, _rotation: float):
	var guts = mob_guts.instantiate()
	guts.position = position
	guts.direction = Vector2.RIGHT
	call_deferred("add_child", guts)

	var guts2 = mob_guts.instantiate()
	guts2.position = position
	guts2.direction = Vector2.UP
	call_deferred("add_child", guts2)

	var guts3 = mob_guts.instantiate()
	guts3.position = position
	guts3.direction = Vector2.LEFT
	call_deferred("add_child", guts3)

	var guts4 = mob_guts.instantiate()
	guts4.position = position
	guts4.direction = Vector2.DOWN
	call_deferred("add_child", guts4)

	score += 1
	if $MobTimer.wait_time > .2 and score % 5 == 0:
		$MobTimer.wait_time -= .1

	$HUD.update_score(score)
	$MobDeath1.play()

	if score % 10 == 0:
		$ResistSound.play()

