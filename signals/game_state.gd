extends Node

signal launch_ball
signal ball_off_screen

# Navigation Signals
signal navigate_to_level_select
signal navigate_to_main_menu
signal level_selected(level: String)


signal card_played(card: Card)
signal coin_played()

signal current_player(player: Player)
