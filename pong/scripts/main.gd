extends Node2D

const COLLIDERS = {
	"top_collider": true,
	"bottom_collider": true,
	"left_collider": false,
	"right_collider": false
}

@export var pong_bar_sc: PackedScene
@export var pong_ball_sc: PackedScene
@export var bar_scale: Vector2

@onready var right_label: Label = $right_label
@onready var left_label: Label = $left_label

var screen_size: Vector2
var right_bar: Node2D
var left_bar: Node2D

func _ready() -> void:
	screen_size = get_viewport_rect().size
	_init_player_bars()
	_init_score_labels()
	_init_ball()
	
func _init_player_bars():
	right_bar = pong_bar_sc.instantiate()
	right_bar.set_name("right_bar")
	right_bar.set_scale(bar_scale)
	right_bar.set_player(1)
	right_bar.position = Vector2(
		screen_size.x/20, 
		screen_size.y/2
	)
	add_child(right_bar)
	
	left_bar = pong_bar_sc.instantiate()
	left_bar.set_name("left_bar")
	left_bar.set_scale(bar_scale)
	left_bar.set_player(2)
	left_bar.position = Vector2(
		screen_size.x - screen_size.x/20, 
		screen_size.y/2
	)
	add_child(left_bar)
	
func _init_score_labels():
	right_label.position = Vector2(
		screen_size.x - right_label.size.x, 
		screen_size.y/20
	)
	right_label.text = "Score: " + str(right_bar.score)

	left_label.position = Vector2(
		screen_size.x/20, 
		screen_size.y/20
	)
	left_label.text = "Score: " + str(left_bar.score)

func _init_ball():
	for child in get_children():
		if child.name == "ball":
			remove_child(child)
	
	var ball_instance: Node2D = pong_ball_sc.instantiate()
	ball_instance.set_name("ball")
	ball_instance.set_scale(bar_scale)
	ball_instance.position = screen_size/2
	ball_instance.ballExitSignal.connect(_update_score)
	add_child(ball_instance)

func _update_score(side: String):
	
	if side == "right":
		left_bar.update_score()
		
	if side == "left":
		right_bar.update_score()
	
	_init_ball()
	_init_score_labels()
