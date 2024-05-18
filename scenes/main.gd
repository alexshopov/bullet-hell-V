extends Node

@export var mob_scene: PackedScene

@export var bullet_scene: PackedScene

@export var mob_guts: PackedScene

var score

func _ready():
	new_game()

func game_over():
	$Timers/MobTimer.stop()
	$HUD.show_game_over()
	$Audio/Music.stop()
	$Audio/DeathSound.play()


func new_game():
	const GROUPS = ["mobs", "guts", "bullets"]
	for group in GROUPS:
		get_tree().call_group(group, "queue_free")

	score = 0
	print($StartPosition.position)
	$Player.start($StartPosition.position)
	$Player.is_active = true
	$Timers/StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Prepare yourself")
	$Audio/Music.play()
	$Audio/NoEscape.play()


func _on_start_timer_timeout():
	$Timers/MobTimer.start()


func _on_mob_timer_timeout():
	spawn_mob()


func spawn_mob():
	var mob = mob_scene.instantiate()
	mob.init_mob($MobPath/MobSpawnLocation, $Player)
	mob.connect("mob_death", _on_mob_death)
	add_child(mob)


func _on_player_shoot_bullet(target):
	var bullet = bullet_scene.instantiate()
	bullet.init_bullet($Player, target, $Audio/PlayerAttack)
	add_child(bullet)


func _on_mob_death(position: Vector2, _rotation: float):
	var num_guts = randi_range(4, 8)
	for n in range(num_guts):
		var guts = mob_guts.instantiate()
		guts.init_guts(position)
		call_deferred("add_child", guts)

	update_score()
	$Audio/MobDeath1.play()


func update_score():
	score += 1
	$HUD.update_score(score)

	if $Timers/MobTimer.wait_time > .25 and score % 5 == 0:
		$Timers/MobTimer.wait_time -= 0.1

	if score % 10 == 0:
		$Audio/ResistSound.play()
