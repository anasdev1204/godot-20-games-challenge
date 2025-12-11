extends Area2D

@export var speed := 50.0

const SPRITE_SIZE := Vector2(64, 64)

@onready var sprite: Sprite2D = $Sprite2D
@onready var explosion_animation: AnimatedSprite2D = $ExplosionAnimation

var rng: RandomNumberGenerator
var direction: Vector2 = Vector2.DOWN
var hits_to_kill: int

func _ready():
	rng = RandomNumberGenerator.new()
	hits_to_kill = rng.randi_range(1, 3)
	sprite.region_rect = Rect2(
		Vector2((hits_to_kill - 1) * SPRITE_SIZE.x, 0),
		SPRITE_SIZE
	)
	
	explosion_animation.animation_finished.connect(_dequeue)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _process(_delta: float) -> void:
	if hits_to_kill == 0:
		sprite.hide()
		explosion_animation.show()
		explosion_animation.play("default")

func _dequeue():
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		hits_to_kill -= 1
		
