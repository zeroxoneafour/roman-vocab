extends Area2D

@export var speed: int

signal laserIsGone

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed * delta

func _on_main_deleteAsteroids():
	emit_signal("laserIsGone")
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("laserIsGone")
	queue_free()
