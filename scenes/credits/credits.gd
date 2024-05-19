class_name Credits
extends Control

func _ready():
	$Music.play()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/startScreen/startScreen.tscn")
