extends Node2D

signal ItemConsumed(item_node: Node2D, effect: String, modifies_score: bool, amount: int)

const RECT_SIZE := Vector2(16, 16)

@onready var sprite: Sprite2D = $Sprite2D

var item: String = "dot"

func _ready() -> void:
	set_item(item)

func set_item(i: String) -> void:
	item = i if Global.ITEMS.has(i) else "dot"
	sprite.region_rect = Rect2(Global.ITEMS[item]["region"], RECT_SIZE)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("pacman"):
		return

	var info = Global.ITEMS[item]
	ItemConsumed.emit(self, info["effect"], info["increment"], info["value"])
