extends Node

@export var mob_scene: PackedScene

@export var bullet_scene: PackedScene

@export var mob_guts: PackedScene

@export var big_boss: PackedScene

var score

var boss_spawned = false
var boss = null

func _ready():
	new_game()

func game_over():
	$Timers/MobTimer.stop()
	$HUD.show_game_over()
	$Audio/Music.stop()

	if boss_spawned:
		$Audio/BossWins.play()
	else:
		$Audio/DeathSound.play()


func new_game():
	score = 0

	const GROUPS = ["mobs", "guts", "bullets", "big boss"]
	for group in GROUPS:
		get_tree().call_group(group, "queue_free")

	$Player.start($StartPosition.position)
	$Player.is_active = true
	$Timers/StartTimer.start()
	$Timers/RingTimer.stop()
	$HUD.update_score(score)
	$HUD.show_message("Prepare yourself")
	$Audio/Music.play()
	$Audio/NoEscape.play()

	boss_spawned = false


func _on_start_timer_timeout():
	$Timers/MobTimer.start()


func _on_mob_timer_timeout():
	spawn_mob()


func spawn_mob():
	var mob = mob_scene.instantiate()

	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	var mob_direction = mob_spawn_location.rotation + PI / 2
	mob_direction += randf_range(-PI / 4, PI / 4)

	mob.init_mob(mob_spawn_location.position, mob_direction, $Player)
	mob.connect("mob_death", _on_mob_death)

	add_child(mob)


func _on_player_shoot_bullet(target):
	var bullet = bullet_scene.instantiate()
	bullet.init_bullet($Player, target, $Audio/PlayerAttack)
	add_child(bullet)


func spawn_boss():
	$Audio/BossSpawn.play()
	boss = big_boss.instantiate()
	boss.get_node("Path").get_node("BossCharacter").connect("boss_death", _on_boss_death)
	call_deferred("add_child", boss)
	get_tree().call_group("mobs", "queue_free")
	$Timers/MobTimer.stop()
	$Timers/RingTimer.start()


func _on_mob_death(position: Vector2, _rotation: float):
	var num_guts = randi_range(6, 12)
	spawn_guts(num_guts, position)

	update_score()
	$Audio/MobDeath1.play()

func spawn_guts(num_guts: int, position: Vector2) -> void:
	var theta = 2 * PI / num_guts
	for n in range(num_guts):
		var guts = mob_guts.instantiate()
		guts.position = position
		guts.direction = Vector2.LEFT.rotated(theta * n).normalized()
		guts.rotation = randf_range(-PI, PI)
		call_deferred("add_child", guts)


func _on_boss_death():
	$Timers/RingTimer.stop()
	$Audio/BossDeath.play()
	$HUD/MessageTimer.wait_time = 6
	$HUD.show_message("To be continued...")
	await get_tree().create_timer(6.0).timeout
	get_tree().change_scene_to_file("res://scenes/credits/credits.tscn")


func update_score():
	score += 1
	$HUD.update_score(score)

	if $Timers/MobTimer.wait_time > .2 and score % 10 == 0:
		$Timers/MobTimer.wait_time -= 0.05

	if score < $HUD/KillBar.max_value && score % 10 == 0:
		$Audio/ResistSound.play()

	if score == $HUD/KillBar.max_value and !boss_spawned:
		spawn_boss()
		boss_spawned = true


func _on_ring_timer_timeout():
	spawn_guts(20, boss.get_pos())

