extends Node2D

const WIDTH = 16

@export var player_bar_sc: PackedScene
@export var ball_sc: PackedScene
@export var block_sc: PackedScene
@export var cols: int
@export var rows: int
@export var ele_scale: Vector2

@onready var left_wall: Node2D = $"Left Wall"
@onready var right_wall: Node2D = $"Right Wall"
@onready var life_container: Control = $Container
@onready var score_label: Label = $Label
@onready var button: Button = $Button

@onready var heart_sprite = load("res://assets/heart.png")
@onready var score_audio = $ScoreAudio

var screen_size: Vector2
var player_bar: Node2D
var ball: Node2D
var score: int
var lives: int


func _ready() -> void:
	screen_size = get_viewport_rect().size
	_init_button()
	_init_walls()
	
func _init_button():
	button.position = Vector2(
		screen_size.x/2 - button.size.x,
		screen_size.y/2 - button.size.y,
	)
	button.set_text("Start game")
	button.pressed.connect(_start_game)
	
func _init_walls():
	left_wall.position.x = screen_size.x/10
	right_wall.position.x = screen_size.x - screen_size.x/10

func _start_game():
	button.hide()
	
	_init_lives()
	_init_score()
	_init_blocks()
	_init_bar()
	_init_ball()
	
func _pause_game():
	remove_child(player_bar)
	remove_child(ball)
	
	for child in get_children():
		if child.is_in_group("blocks"):
			remove_child(child)
	
	button.set_text("Retry?")
	button.show()
	
func _init_blocks():
	for r in rows:
		for c in cols:
			var temp_block = block_sc.instantiate()
			temp_block.add_to_group("blocks")
			temp_block.position = Vector2(
				left_wall.position.x + (WIDTH * scale.x + 26) * (c+1),
				50 * (r+1)
			)
			
			add_child(temp_block)
	
func _init_bar():
	player_bar = player_bar_sc.instantiate()
	player_bar.set_scale(ele_scale)
	player_bar.set_limits(
		left_wall.position.x, 
		right_wall.position.x
	)
	player_bar.position = Vector2(
		screen_size.x/2,
		screen_size.y - screen_size.y/20
	)
	add_child(player_bar)
	
func _init_ball():
	for child in get_children():
		if child.name == "ball":
			remove_child(child)
			
	ball = ball_sc.instantiate()
	ball.set_name("ball")
	ball.set_scale(ele_scale)
	ball.position = screen_size/2
	ball.ballExitSignal.connect(_update_lives)
	ball.ballCollideWithBlock.connect(_update_score)
	add_child(ball)
	
func _init_lives():
	lives = 3
	_render_lives()
	
func _render_lives():
	for child in life_container.get_children():
		life_container.remove_child(child)
	
	for l in range(lives):
		var temp_heart: TextureRect = TextureRect.new()
		temp_heart.texture = heart_sprite
		temp_heart.set_scale(Vector2(3, 3))
		temp_heart.position = Vector2(
			25,
			50 * (l+1)
		)
		life_container.add_child(temp_heart)

func _update_lives():
	lives -= 1
	
	if lives <= 0:
		_pause_game()
	else:
		_init_ball()
		
	_render_lives()
	
func _init_score():
	score = 0
	score_label.position = Vector2(
		screen_size.x - 100,
		50
	)
	_render_score()
	
func _render_score():
	var score_length = str(score).length()
	var temp_text = "0000" + str(score)
	score_label.set_text(temp_text.substr(score_length-1))

func _update_score(block_id: int):
	var hit_block := instance_from_id(block_id)
	remove_child(hit_block)
	score_audio.play()
	
	score += 1
	ball.update_velocity()
	_render_score()
