extends Node2D

@export var gcard: PackedScene;

var number_grid = [[0, 10, 12, 13, 14, 2, 3, 4, 5, 0],
					[9, 10, 9, 8, 7, 6, 5, 4, 3, 6],
					[8, 12, 7, 8, 9, 10, 12, 13, 2, 7]]
				
var suit_grid = [
					["J", "S", "S", "S", "S", "D", "D", "D", "D", "J"],
					["S", "H", "H", "H", "H", "H", "H", "H", "H", "D"],
					["S", "H", "D", "D", "D", "D", "D", "D", "H", "D"]]
					
var board = [
				["J", "S10", "SQ", "SK", "SA", "D2", "D3", "D4", "D5", "J"],
				["S9", "H10", "H9", "H8", "H7", "H6", "H5", "H4", "H3", "D6"],
				["S8", "HQ", "D7", "D8", "D9", "D10", "DQ", "DK", "H2", "D7"],
				["S7", "HK", "D6", "C2", "HA", "HK", "HQ", "DA", "S2", "D8"],
				["S6", "HA", "D5", "C3", "H4", "H3", "H10", "CA", "S3", "D9"],
				["S5", "C2", "D4", "C4", "H5", "H2", "H9", "CK", "S4", "D10"],
				["S4", "C3", "D3", "C5", "H6", "H7", "H8", "CQ", "S5", "DQ"],
				["S3", "C4", "D2", "C6", "C7", "C8", "C9", "C10", "S6", "DK"],
				["S2", "C5", "SA", "SK", "SQ", "S10", "S9", "S8", "S7", "DA"],
				["J", "C6", "C7", "C8", "C9", "C10", "CQ", "CK", "CA", "J"]]
					
var deck = []

var hand = []
				
#var card_grid = [[], [], []]

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.card_played.connect(play_card)
	
	#for row in 10:
		#for col in 10:
			#var temp_val_card = board[row][col]
			#
			#if temp_val_card != "J":
				#deck.append(board[row][col])

	deck.append("DJ2E")
	deck.append("DJ2E")
	deck.append("HJ1E")
	deck.append("HJ1E")
	deck.append("CJ2E")
	deck.append("CJ2E")
	deck.append("SJ1E")
	deck.append("SJ1E")
	deck.shuffle()
			
	for row in 10:
		for col in 10:
			var card = gcard.instantiate()
			card.position = Vector2(100 + col*140, 100 + row*100)
			add_child(card)
			card.setup2(board[row][col], true)
			
	deal_cards()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func deal_cards():
	for i in 7:
		var card_val = deck.pop_back()
		var card = gcard.instantiate()
		add_child(card)
		card.setup2(card_val, false)
		hand.append(card)
		card.position = Vector2(1800, 100 + i*140)
		card.rotation = 0
	
func play_card(card: Card):
	if card != null:
		var c:Card = gcard.instantiate()
		add_child(c)
		c.setup2(card.card_val_glob, false)
		c.position = Vector2(2200 , 700)
		c.rotation = 0
		hand.erase(card)
		draw_hand()

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


func _on_button_pressed():
	var a = deck.pop_back()
	var card = gcard.instantiate()
	add_child(card)
	card.setup2(a, false)
	hand.append(card)
	draw_hand()
