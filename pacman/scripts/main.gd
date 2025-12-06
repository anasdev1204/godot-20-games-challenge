extends Node2D

var player_state := {
	"score": 0,
	"life": 3,
	"power_pellet": false
}

@export var pacman_scn: PackedScene 
@export var ghost_scn: PackedScene 
@export var item_scn: PackedScene

@onready var score_value: Label = $Score/ScoreValue
@onready var life_container: Control = $Life
@onready var spawn_container: Node2D = $Spawns
@onready var map_container: Node2D = $Map
@onready var items_container: Node2D = $Items
@onready var item_layer: TileMapLayer = $Map/ItemLayer
@onready var doors_layer: TileMapLayer = $Map/Doors
@onready var life_sprite: Resource = load("res://assets/life.png")

var rng: RandomNumberGenerator
var pacman: CharacterBody2D
var ghosts: Array[Node2D]

func _ready():
	rng = RandomNumberGenerator.new()
	_update_score()
	_update_life()
	
	_init_ghosts()
	_init_items()
	
func _process(_delta: float):
	pass

func _init_ghosts():
	for child in spawn_container.get_children():
		if "Pacman" in child.name:
			pacman = pacman_scn.instantiate()
			pacman.position = child.position
			add_child(pacman)
			continue
			
		var ghost_color := child.name.substr(5).to_lower()
		var temp_ghost := ghost_scn.instantiate()
		temp_ghost.set_name("Ghost%s" % str(ghost_color))
		temp_ghost.position = child.position
		ghosts.append(temp_ghost)
		add_child(temp_ghost)
		temp_ghost.call_deferred("set_ghost", ghost_color)

func _init_items():
	var item_options := Global.ITEMS.keys()
	var item_odds:= Global.ITEM_ODDS

	for cell in item_layer.get_used_cells():
		var temp := rng.randfn(0, 1)
		if temp < 0:
			continue
		
		var temp_item = item_scn.instantiate()
		temp_item.position = item_layer.map_to_local(cell) + map_container.position
		temp_item.ItemConsumed.connect(_handle_update_state)
		items_container.add_child(temp_item)
		
		temp_item.call_deferred("set_item", item_options[rng.rand_weighted(item_odds)])

func _update_life():
	for child in life_container.get_children():
		life_container.remove_child(child)
	
	for l in range(player_state["life"]):
		var temp_life := TextureRect.new()
		temp_life.texture = life_sprite
		temp_life.set_scale(Vector2(0.75, 0.75))
		temp_life.position = Vector2(
			32 * 0.75 * l + 10,
			0
		)
		life_container.add_child(temp_life)
	
func _update_score():
	var score_length = str(player_state["score"]).length()
	var temp_text = "0000" + str(str(player_state["score"]))
	score_value.set_text(temp_text.substr(score_length-1))

func _handle_power_pellet():
	player_state["power_pellet"] = true
	for ghost in ghosts:
		ghost.toggle_scared(true)
	await get_tree().create_timer(5).timeout
	for ghost in ghosts:
		ghost.toggle_scared(false)
	player_state["power_pellet"] = false

func _handle_update_state(item_node: Node2D, effect: String, increments: bool, value):	
	match effect:
		"score":
			player_state["score"] += value * (1 if increments else -1)
			_update_score()
			if player_state["score"] >= 50:
				_free_ghosts()
		"life":
			if increments and player_state["life"] == 3:
				return
				
			player_state["life"] += value * (1 if increments else -1)
			if not increments:
				pacman.hit(player_state["life"])
		"power_pellet":
			_handle_power_pellet()
			
	item_node.call_deferred("queue_free")

func _free_ghosts():
	doors_layer.hide()
