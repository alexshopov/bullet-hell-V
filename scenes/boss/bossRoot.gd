extends Path2D

func get_pos() -> Vector2:
	return $Path/BossCharacter.global_position

func get_bigboss() -> CharacterBody2D:
	return get_node("Path").get_node("BossCharacter")