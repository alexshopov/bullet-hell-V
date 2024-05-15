extends Node

@export var mob_scene: PackedScene

@export var bullet_scene: PackedScene

@export var mob_guts: PackedScene

var score
const GROUPS = ["mobs", "guts", "bullets"]

func game_over():
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


func new_game():
	for group in GROUPS:
		get_tree().call_group(group, "queue_free")

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
	mob.init_mob($MobPath/MobSpawnLocation, $Player)
	mob.connect("mob_death", _on_mob_death)
	add_child(mob)


func _on_player_shoot_bullet(target):
	var bullet = bullet_scene.instantiate()
	bullet.init_bullet($Player, target, $PlayerAttack)
	add_child(bullet)


func _on_mob_death(position: Vector2, _rotation: float):
	var directions = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
	for direction in directions:
		var guts = mob_guts.instantiate()
		guts.init_guts(position, direction)
		call_deferred("add_child", guts)

	update_score()
	$MobDeath1.play()


func update_score():
	score += 1
	$HUD.update_score(score)

	if $MobTimer.wait_time > .2 and score % 5 == 0:
		$MobTimer.wait_time -= .1

	if score % 10 == 0:
		$ResistSound.play()