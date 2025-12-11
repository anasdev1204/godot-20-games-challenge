extends Node2D

const RENDER_DISTANCE = 150
const TEXTURE_HEIGHT = 296

@export var ship_sc: PackedScene
@export var asteriod_sc: PackedScene
@export var asteroid_spawn_rate: float = 0.5

@onready var collision_shape: StaticBody2D = $Collisions
@onready var background_container: Node2D = $Backgrounds
@onready var background_texture: Texture = load("res://assets/Background_space.png")
@onready var right_spawn_marker: Marker2D = $RightSpawnMarker
@onready var left_spawn_marker: Marker2D = $LeftSpawnMarker

var player_ship: CharacterBody2D
var player_y_speed : float
var render_index: float = 0
var asteroid_spawn_cooldown: float = 0
var rng: RandomNumberGenerator

func _ready():
	rng = RandomNumberGenerator.new()
	_init_player_ship()
	_render_background()
	
func _process(delta: float):
	collision_shape.position.y -= player_y_speed * delta

	if abs(player_ship.global_position.y) >= RENDER_DISTANCE * render_index:
		render_index += 1
		_render_background()
		
	asteroid_spawn_cooldown -= delta
	
	if asteroid_spawn_cooldown <= 0:
		asteroid_spawn_cooldown = asteroid_spawn_rate
		
		_spawn_asteroid()
		
func _init_player_ship():
	player_ship = ship_sc.instantiate()
	player_ship.global_position = Vector2.ZERO
	player_y_speed = player_ship.get_speed().y
	add_child(player_ship)
	
func _render_background():
	var temp_sprite := Sprite2D.new()
	temp_sprite.texture = background_texture
	temp_sprite.global_position.y = -TEXTURE_HEIGHT * render_index
	background_container.add_child(temp_sprite)

func _spawn_asteroid():
	var temp_spawn_x := rng.randf_range(left_spawn_marker.global_position.x, right_spawn_marker.global_position.x)
	var temp_asteroid := asteriod_sc.instantiate()
	temp_asteroid.global_position = Vector2(temp_spawn_x, right_spawn_marker.global_position.y * render_index)
	add_child(temp_asteroid)
