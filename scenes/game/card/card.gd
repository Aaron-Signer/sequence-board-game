class_name Card extends Node2D

@onready var card: Sprite2D = $CardSprite
@export var coin: PackedScene

var loaded_coin:Node2D

var card_val_glob
var is_board_card:bool = false
var played_card: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.card_played.connect(set_hightlight)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func setup2(card_val, is_board_crd):
	card_val_glob = card_val
	var path = "res://assets/cards/" + card_val + ".png"
	var main = load(path)
	card.texture = main
	is_board_card = is_board_crd
	
func setup(suit, number):
	var s
	var n
	
	match suit:
		"S":
			s = suit
		"D":
			s = suit
		"C":
			s = suit
		"H":
			s = suit
		"J":
			s = "Joker"
			
			
	if number >= 2 && number <= 10:
		n = str(number)
	elif number == 12:
		n = "Q"
	elif number == 13:
		n = "K"
	elif number == 14:
		n = "A"
	elif number == 0:
		n = ""
		
	var path = "res://assets/cards/" + s + n + ".png"
	var main = load(path)
	card.texture = main


func _on_area_2d_mouse_entered():
	if loaded_coin != null:
		card.modulate = Color(1, 0, 0, 1)
	else:
		card.modulate = Color(.5, .5, .5, 1)
		
func _on_area_2d_mouse_exited():
	card.modulate = Color(1, 1, 1, 1)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LC") && loaded_coin == null:
		if is_board_card && played_card == card_val_glob && card_val_glob != "J":
			loaded_coin = coin.instantiate()
			add_child(loaded_coin)
			loaded_coin.position = Vector2(0,0)
			GameState.card_played.emit(null)
		elif !is_board_card:
			GameState.card_played.emit(self)
			queue_free()
	
func set_hightlight(card2: Card):	
	if card2 != null:		
		played_card = card2.card_val_glob
		if card_val_glob == card2.card_val_glob && is_board_card:
			if loaded_coin == null:
				card.modulate = Color(0, 0, 1, 1)
			else:
				card.modulate = Color(1, 0, 0, 1)
		else:
			card.modulate = Color(1, 1, 1, 1)
	else:
		played_card = ""
	


func _on_button_pressed():
	print("button pressed")
