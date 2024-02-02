extends Node

const SAVE_LOCATION = "user://savegame.tres"

func save_game():
	var saved_game := SavedGame.new()
	saved_game.player_stats = PlayerStats.stats
	
	ResourceSaver.save(saved_game, SAVE_LOCATION)
	
func load_game():
	var saved_game: SavedGame = ResourceLoader.load(SAVE_LOCATION)
	
	PlayerStats.stats = saved_game.player_stats
