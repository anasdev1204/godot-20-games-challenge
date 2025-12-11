extends CharacterBody2D

@export var speed: Vector2 = Vector2(300, 150)
@export var projectile: PackedScene
@export var fire_frequency: float = 1

@onready var firing_animation := $FiringAnimation

var fire_cooldown := 0.0

func _ready():
	firing_animation.hide()

func _physics_process(_delta: float):
	var horizantal_velocity := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity = Vector2(horizantal_velocity, -1) * speed
	rotation_degrees = lerp(rotation_degrees, 6 * horizantal_velocity, 0.1)
	
	move_and_slide()
	
func _process(delta: float) -> void:
	fire_cooldown -= delta
	
	if Input.is_action_pressed("shoot") and fire_cooldown <= 0.0:
		if !firing_animation.is_playing():
			firing_animation.show()
			firing_animation.play("default")
		
		_fire_shot()
		fire_cooldown = fire_frequency
	else:
		firing_animation.stop()
		firing_animation.hide()
		
func _fire_shot():
	var temp_shot := projectile.instantiate()
	temp_shot.global_position = global_position + Vector2(0, -32) 
	get_tree().current_scene.add_child(temp_shot)
		
func get_speed() -> Vector2:
	return speed
