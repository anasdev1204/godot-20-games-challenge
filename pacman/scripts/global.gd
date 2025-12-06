extends Node

const ITEMS := {
	"cherry": {
		"region": Vector2(0, 0),
		"effect": "life",
		"increment": true,
		"value": 1
	},
	"strawberry": {
		"region": Vector2(16, 0),
		"effect": "power_pellet",
		"increment": false,
		"value": null
	},
	"dot": {
		"region": Vector2(0, 16),
		"effect": "score",
		"increment": true,
		"value": 1
	},
	"big_dot": {
		"region": Vector2(16, 16),
		"effect": "score",
		"increment": true,
		"value": 10
	}
}

var ITEM_ODDS := PackedFloat32Array([0.1, 0.1, 5, 1])
