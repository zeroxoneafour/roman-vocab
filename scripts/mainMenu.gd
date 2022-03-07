extends Control

signal clickedPlay

func _on_button_pressed():
	emit_signal("clickedPlay")
	hide()
