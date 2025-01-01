class_name Card extends Node2D

@onready var card: Sprite2D = $CardSprite
@export var coin: PackedScene

var loaded_coin: Coin
var placeholder_coin: Coin

var card_val_glob
var is_board_card:bool = false
var played_card: String = ""

var player: Player = null

var team_1_color: Color = Color(0, 1, 1, 1)
var team_2_color: Color = Color(1, 0, 0, 1)
var team_3_color: Color = Color(1, 1, 1, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.card_played.connect(set_hightlight)

func setup2(card_val, is_board_crd):
	card_val_glob = card_val
	var path = "res://assets/cards/" + card_val + ".png"
	var main = load(path)
	if card != null:
		card.texture = main
	is_board_card = is_board_crd

func _on_area_2d_mouse_entered():
	if loaded_coin != null:
		card.modulate = Color(1, 0, 0, 1)
	else:
		card.modulate = Color(.5, .5, .5, 1)
		
func _on_area_2d_mouse_exited():
	card.modulate = Color(1, 1, 1, 1)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LC") && loaded_coin == null:
		if is_board_card && (played_card == card_val_glob && card_val_glob != "J") || played_card.contains("2E"):
			loaded_coin = coin.instantiate()
			add_child(loaded_coin)
			loaded_coin.position = Vector2(0,0)
			
			if player.team == 1:
				loaded_coin.modulate = team_1_color
				
			if player.team == 2:
				loaded_coin.modulate = team_2_color
			GameState.card_played.emit(null)
			
			if placeholder_coin != null:
				placeholder_coin.queue_free()
		elif !is_board_card:
			var player_move = PlayerMove.new(player, self)
			GameState.card_played.emit(player_move)
			queue_free()
	
func set_hightlight(player_move: PlayerMove):
	if player_move != null:
		var temp_card: Card = player_move.card
		var temp_player: Player = player_move.player
		played_card = temp_card.card_val_glob
		
		if played_card.contains("2E") && loaded_coin == null:
			placeholder_coin = coin.instantiate()
			add_child(placeholder_coin)
			placeholder_coin.make_transparent()
		else:
			if card_val_glob == temp_card.card_val_glob && is_board_card:
				if loaded_coin == null:
					placeholder_coin = coin.instantiate()
					add_child(placeholder_coin)
					player = temp_player
					
					if player.team == 1:
						placeholder_coin.modulate = team_1_color
				
					if player.team == 2:
						placeholder_coin.modulate = team_2_color
						
					placeholder_coin.make_transparent()

				else:
					card.modulate = Color(1, 0, 0, 1)
			else:
				if placeholder_coin != null:
					placeholder_coin.queue_free()
				#card.modulate = Color(1, 1, 1, 1)
	else:
		played_card = ""
		if placeholder_coin != null:
			placeholder_coin.queue_free()
		#card.modulate = Color(1, 1, 1, 1)
