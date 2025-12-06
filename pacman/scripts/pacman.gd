extends CharacterBody2D

@export var speed := 100

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	anim.play("default")
	_move_forward()
	
func _process(_delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		velocity = Vector2(-1, 0) * speed
		rotation_degrees = 180
	elif  Input.is_action_pressed("move_left"):
		velocity = Vector2(1, 0) * speed
		rotation_degrees = 0
	elif  Input.is_action_pressed("move_down"):
		velocity = Vector2(0, 1) * speed
		rotation_degrees = 90
	else:
		_move_forward()
		
func _physics_process(delta: float):
	var collision = move_and_collide(velocity * delta)
	
	if collision: 
		velocity = velocity.bounce(collision.get_normal())

func _move_forward():
	velocity = Vector2(0, -1) * speed
	rotation_degrees = -90
	
func hit(remaning_lives: int):
	if remaning_lives == 0:
		die()
	
	animation_player.play("hit")
		
func die():
	anim.play("death")
