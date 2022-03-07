extends Area2D

@export var speed: int
@export var number: int
@export var text: String

signal hitByLaser(number: int)
signal gameOver

func _on_main_deleteAsteroids():
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect/Label.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta

func _on_asteroid_area_entered(area):
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("hitByLaser", number)


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("gameOver")
