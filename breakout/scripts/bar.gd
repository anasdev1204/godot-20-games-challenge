extends Node2D

@export var speed = 400

const WIDTH = 16

var screen_size: Vector2
var left_limit: float
var right_limit: float

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO 
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if  Input.is_action_pressed("move_left"):
		velocity.x -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta
	position = position.clamp(
		Vector2(left_limit + WIDTH * scale.x, position.y), 
		Vector2(right_limit - WIDTH * scale.x, position.y)
	)
	
func set_limits(left: float, right: float):
	left_limit = left
	right_limit = right
