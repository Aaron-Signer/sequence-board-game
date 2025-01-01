extends Node2D

@export var gcard: PackedScene
@export var player: PackedScene
@onready var current_player_name_label: RichTextLabel = $NameLabel

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

var player_1: Player = null
var player_2: Player = null

var current_player: Player = null

var player_list:Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.card_played.connect(play_card)
	GameState.current_player.connect(next_player)
	
	player_1 = player.instantiate()
	player_1.player_name = "Aaron"
	player_1.team = 1
	add_child(player_1)
	
	player_2 = player.instantiate()
	player_2.player_name = "Sarah"
	player_2.team = 2
	add_child(player_2)
	
	player_list.append(player_1)
	player_list.append(player_2)

	for row in 10:
		for col in 10:
			var temp_val_card = board[row][col]
			
			if temp_val_card != "J":
				deck.append(board[row][col])

	deck.append("DJ2E")
	deck.append("DJ2E")
	deck.append("HJ1E")
	deck.append("HJ1E")
	#deck.append("CJ2E")
	deck.append("SJ1E")
	deck.shuffle()
	deck.append("CJ2E")
	deck.append("CJ2E")

	deck.append("SJ1E")
			
	for row in 10:
		for col in 10:
			var card = gcard.instantiate()
			card.position = Vector2(100 + col*140, 100 + row*100)
			add_child(card)
			card.setup2(board[row][col], true)
			
	deal_cards()
	
	GameState.current_player.emit(player_1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func next_player(player: Player) -> void:
	current_player = player
	current_player_name_label.text = current_player.player_name
	
	for i in player_list.size():
		if player_list[i] != current_player:
			player_list[i].hide_hand()
	
	current_player.draw_hand()

func deal_cards():
	for i in 7:
		var card_val = deck.pop_back()
		var card: Card = gcard.instantiate()
		card.player = player_1
		player_1.add_card_to_hand(card_val, player_1)

		card_val = deck.pop_back()
		var card2: Card = gcard.instantiate()
		card2.player = player_2
		player_2.add_card_to_hand(card_val, player_2)

func play_card(player_move: PlayerMove):
	if player_move != null && player_move.card != null:
		var played_card:Card = gcard.instantiate()
		add_child(played_card)
		played_card.setup2(player_move.card.card_val_glob, false)
		played_card.position = Vector2(1600 , 350)
		played_card.rotation = 0
		current_player.remove_card_from_hand(player_move.card)
		current_player.draw_hand()

# Draw card button
func _on_button_pressed():
	var drawn_card_value = deck.pop_back()
	current_player.add_card_to_hand(drawn_card_value, current_player)
	get_next_player()
	
func get_next_player() -> void:
	var current_player_index:int = player_list.find(current_player)
	current_player_index += 1
	
	if current_player_index == player_list.size():
		current_player_index = 0
		
	GameState.current_player.emit(player_list[current_player_index])
