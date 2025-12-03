extends CharacterBody2D

@export var speed: int = 300

const HEIGHT: int = 4

@onready var bounce_audio: AudioStreamPlayer2D = $BounceAudio

var screen_size: Vector2
var rng: RandomNumberGenerator

signal ballExitSignal
signal ballCollideWithBlock

func _ready() -> void:
	screen_size = get_viewport_rect().size
	 
	rng = RandomNumberGenerator.new()
	
	var temp_y = rng.randf_range(0.5, 1)
	var temp_x = rng.randf_range(-0.5, 0.5)
	var epislon = rng.randfn(0, 0.1)
	var direction_vector = Vector2(temp_x + epislon, temp_y + epislon)
	
	velocity = direction_vector.normalized() * speed
	
func _process(_delta: float) -> void:
	if position.y >= screen_size.y:
		ballExitSignal.emit()
		
		
func _physics_process(delta: float):
	var collision = move_and_collide(velocity * delta)
	
	if collision: 
		var body = collision.get_collider()
		
		if body.is_in_group("blocks"):
			ballCollideWithBlock.emit(body.get_instance_id())
		
		velocity = velocity.bounce(collision.get_normal())
		bounce_audio.play()

func update_velocity():
	speed += 20
	velocity = velocity.normalized() * speed
