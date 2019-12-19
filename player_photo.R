library(readr)

players = read_csv("players_info.csv")

find_player_by_name = function(pname){
  players[tolower(players$name) == tolower(pname),]
}

default_player = find_player_by_name("James Harden")
default_season = "2018-19"
default_season_type = "Regular Season"

photo_by_id = function(id){
  paste0("https://stats.nba.com/media/players/230x185/", id, ".png")
}
