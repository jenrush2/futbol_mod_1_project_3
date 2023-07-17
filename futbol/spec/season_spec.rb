#tests for a delted class after refactoring

# require './lib/team.rb'
# require './lib/game.rb'
# require './lib/season.rb'
# require 'rspec'
# require 'CSV'

# RSpec.describe Season do
#     it 'exists' do
#         season_2012_2013 = Season.new("20122013")

#         expect(season_2012_2013).to be_an_instance_of Season
#     end

#     it 'has attributes' do 
#         season_2012_2013 = Season.new("20122013")

#         expect(season_2012_2013.season_years).to eq "20122013"
#         expect(season_2012_2013.games).to eq([])
#     end

#     it 'can add a game' do
#         season_2012_2013 = Season.new("20122013")
        
#         array_of_games_hashes = []
#         CSV.foreach('./data/games_test.csv', :headers => true, :header_converters => :symbol) do |row|
#             array_of_games_hashes << Hash[row.headers.zip(row.fields)]
#             array_of_games_hashes
#         end

#         test_game_1 = Game.new(array_of_games_hashes[0])
#         test_game_2 = Game.new(array_of_games_hashes[1])
#         test_game_3 = Game.new(array_of_games_hashes[2])


#         season_2012_2013.add_game(test_game_1)
#         season_2012_2013.add_game(test_game_2)
#         season_2012_2013.add_game(test_game_3)

#         expect(season_2012_2013.games).to be_an_instance_of Array 
#         expect(season_2012_2013.games[0]).to be_an_instance_of Game 
#         expect(season_2012_2013.games).to eq([test_game_1, test_game_2, test_game_3])
#     end
        



# end