class_name HUD
extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartButton.hide()
	$MessageTimer.wait_time = 3


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$KillBar.value = score


func _on_message_timer_timeout():
	$Message.hide()

func _on_start_button_pressed():
	$Message.text = "Prepare yourself"
	$Message.show()

	$StartButton.hide()
	start_game.emit()
