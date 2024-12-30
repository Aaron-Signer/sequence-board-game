extends Node2D
class_name Player

@export var gcard: PackedScene

var player_name: String = ""
var hand: Array[Card] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_card_to_hand(card_val: String) -> void:
	var card = gcard.instantiate()
	add_child(card)
	card.setup2(card_val, false)
	hand.append(card)

func remove_card_from_hand(card: Card) -> void:
	hand.erase(card)
	
func draw_hand():
	var temp_hand = hand.duplicate()
	
	for i in hand.size():
		hand[i].queue_free()
		
	hand.clear()
		
	for i in temp_hand.size():
		var card = gcard.instantiate()
		hand.append(card)
		add_child(card)
		card.setup2(temp_hand[i].card_val_glob, false)
		card.position = Vector2(1800, 100 + i*140)
		card.rotation = 0
		
func hide_hand() -> void:
	for i in hand.size():
		hand[i].visible = false
