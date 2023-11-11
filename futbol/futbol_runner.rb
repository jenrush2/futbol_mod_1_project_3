require './lib/stat_tracker'
require 'CSV'

game_path = './data/games_test.csv'
team_path = './data/teams_test.csv'
game_teams_path = './data/game_teams_test.csv'

locations = {
  games: game_path,
  teams: team_path,
  game_teams: game_teams_path
}

stat_tracker = StatTracker.from_csv(locations)

require 'pry'; binding.pry

# [1] pry(main)> CSV.foreach(stat_tracker.games, headers: true) do |row|
# [1] pry(main)*   print row
# [1] pry(main)* end  
# 2012030221,20122013,Postseason,5/16/13,3,6,2,3,Toyota Stadium,/api/v1/venues/null
# 2012030222,20122013,Postseason,5/19/13,3,6,2,3,Toyota Stadium,/api/v1/venues/null
# 2012030223,20122013,Postseason,5/21/13,6,3,2,1,BBVA Stadium,/api/v1/venues/null
# 2012030224,20122013,Postseason,5/23/13,6,3,3,2,BBVA Stadium,/api/v1/venues/null
# 2012030161,20122013,Postseason,5/1/13,17,24,1,3,Rio Tinto Stadium,/api/v1/venues/null