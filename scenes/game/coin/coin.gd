extends Node2D
class_name Coin
@onready var coinSprite: Sprite2D = $GoldCoin

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func make_transparent():
	modulate = Color(.102, .839, .796, .6)