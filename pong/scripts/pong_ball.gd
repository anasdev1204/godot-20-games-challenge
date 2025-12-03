extends CharacterBody2D

@export var speed: int = 300

const HEIGHT: int = 4

@onready var bounce_audio: AudioStreamPlayer2D = $BounceAudio
@onready var score_audio: AudioStreamPlayer2D = $ScoreAudio

var screen_size: Vector2
var rng: RandomNumberGenerator

signal ballExitSignal

func _ready() -> void:
	screen_size = get_viewport_rect().size
	 
	rng = RandomNumberGenerator.new()
	
	var temp = rng.randf()
	var direction_vector = Vector2.ONE
	direction_vector *= 1 if temp > 0.5 else -1 
	
	velocity = direction_vector.normalized() * speed
	
func _process(_delta: float) -> void:
	if position.x <= 0 or position.x >= screen_size.x:
		score_audio.play()
		ballExitSignal.emit("left" if position.x <= 0 else "right")
		
		
func _physics_process(delta: float):
	var collision = move_and_collide(velocity * delta)
	
	if collision: 
		velocity = velocity.bounce(collision.get_normal())
		bounce_audio.play()
