extends Node2D

@export var speed = 400

const HEIGHT = 16
const PLAYER_MOVEMENTS = {
	1: ["move_down", "move_up"],
	2: ["move_down_opp", "move_up_opp"]
}

var screen_size: Vector2
var player: int
var score: int = 0


func _ready():
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	if player == 0:
		return
	
	var velocity = Vector2.ZERO 
	
	if Input.is_action_pressed(PLAYER_MOVEMENTS[player][0]):
		# down
		velocity.y += 1
	if  Input.is_action_pressed(PLAYER_MOVEMENTS[player][1]):
		# up
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta
	position = position.clamp(
		Vector2(0, HEIGHT * scale.y), 
		screen_size - Vector2(0, HEIGHT * scale.y)
	)
	
func set_player(pl: int):
	player = pl
	
func update_score():
	score += 1
