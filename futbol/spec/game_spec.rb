require './lib/game.rb'
require 'rspec'
require 'CSV'

RSpec.describe Game do
    it 'exists' do
        array_of_games_hashes = []
        CSV.foreach('./data/games_test.csv', :headers => true, :header_converters => :symbol) do |row|
            array_of_games_hashes << Hash[row.headers.zip(row.fields)]
            array_of_games_hashes
        end

        test_game = Game.new(array_of_games_hashes[0])

        expect(test_game).to be_an_instance_of Game
    end

    it 'has attributes' do
        array_of_games_hashes = []
        CSV.foreach('./data/games_test.csv', :headers => true, :header_converters => :symbol) do |row|
            array_of_games_hashes << Hash[row.headers.zip(row.fields)]
            array_of_games_hashes
        end

        test_game = Game.new(array_of_games_hashes[0])

        expect(test_game.game_id).to eq "2012030221"
        expect(test_game.season).to eq "20122013"
        expect(test_game.type).to eq "Postseason"
        expect(test_game.date_time).to eq "5/16/13"
        expect(test_game.away_team_id).to eq "3"
        expect(test_game.home_team_id).to eq "6"
        expect(test_game.away_goals).to eq "2"
        expect(test_game.home_goals).to eq "3"
        expect(test_game.venue).to eq "Toyota Stadium"
        expect(test_game.venue_link).to eq "/api/v1/venues/null"
    end



end