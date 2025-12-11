extends Area2D

@export var speed := 300.0

@onready var bullet_sprite: Sprite2D = $Sprite2D
@onready var explosion_animation: AnimatedSprite2D = $ExplosionAnimation

var direction := Vector2.UP

func _ready():
	explosion_animation.animation_finished.connect(_dequeue)

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_body_entered(_body: Node2D) -> void:
	_explode()

func _on_area_entered(_area: Area2D) -> void:
	_explode()

func _dequeue():
	queue_free()
	
func _explode():
	bullet_sprite.hide()
	explosion_animation.show()
	explosion_animation.play("default")
