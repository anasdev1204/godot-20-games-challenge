extends CharacterBody2D

const GHOST_COLORS := ["red", "blue", "pink", "orange"]
const FACE_OFFSET := 320.0
const NUMBER_OF_FACES: int = 112/16
const FACE_SIZE := 16

@export var speed := 100

@onready var ghost_sprite: AnimatedSprite2D = $GhostSprite
@onready var face_sprite: Sprite2D = $FaceSprite

var rng: RandomNumberGenerator
var ghost_color: String

func _ready():
	rng = RandomNumberGenerator.new()
	
	var temp_multiplier := rng.randi_range(0, NUMBER_OF_FACES)
	face_sprite.region_rect = Rect2(
		Vector2(FACE_SIZE * temp_multiplier, FACE_OFFSET), 
		Vector2(FACE_SIZE, FACE_SIZE)
	)
	
func _process(_delta: float) -> void:
	_move_forward()
		
func _physics_process(delta: float):
	var collision = move_and_collide(velocity * delta)
	
	if collision: 
		velocity = velocity.bounce(collision.get_normal())

func _move_forward():
	velocity = Vector2(0, -1) * speed
	
func toggle_scared(scared: bool):
	if scared:
		ghost_sprite.play("scared")
		face_sprite.hide()
	else:
		ghost_sprite.play(ghost_color)
		face_sprite.show()
	
func set_ghost(color: String):
	ghost_color = color if color in GHOST_COLORS else "blue"
	ghost_sprite.play(ghost_color)
