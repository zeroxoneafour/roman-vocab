extends Sprite2D

@export var speed = 400
var screenSize

# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = 0 # The player's movement vector.
	if Input.is_action_pressed("moveRight"):
		velocity += 1
	if Input.is_action_pressed("moveLeft"):
		velocity -= 1
	
	position.x += velocity * speed * delta
	position.x = clamp(position.x, 0, screenSize.x)
