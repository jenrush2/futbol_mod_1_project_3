require './lib/game_team.rb'
require 'rspec'
require 'CSV'
require 'pry'

RSpec.describe Game_Team do
    it 'exists' do
        array_of_game_team_hashes = []
        CSV.foreach('./data/game_teams_test.csv', :headers => true, :header_converters => :symbol) do |row|
            array_of_game_team_hashes << Hash[row.headers.zip(row.fields)]
            array_of_game_team_hashes
        end
        game_team_test = Game_Team.new(array_of_game_team_hashes[0])

        expect(game_team_test).to be_an_instance_of Game_Team 
    end

    it 'has attributes' do
        array_of_game_team_hashes = []
        CSV.foreach('./data/game_teams_test.csv', :headers => true, :header_converters => :symbol) do |row|
            array_of_game_team_hashes << Hash[row.headers.zip(row.fields)]
            array_of_game_team_hashes
        end
        game_team_test = Game_Team.new(array_of_game_team_hashes[0])

        expect(game_team_test.game_id).to eq "2012030221"
        expect(game_team_test.team_id).to eq "3"
        expect(game_team_test.hoa).to eq "away"
        expect(game_team_test.result).to eq "LOSS"
        expect(game_team_test.settled_in).to eq "OT"
        expect(game_team_test.head_coach).to eq "John Tortorella"
        expect(game_team_test.goals).to eq "2"
        expect(game_team_test.shots).to eq "8"
        expect(game_team_test.tackles).to eq "44"
        expect(game_team_test.pim).to eq "8"
        expect(game_team_test.powerplayopportunities).to eq "3"
        expect(game_team_test.powerplaygoals).to eq "0"
        expect(game_team_test.faceoffwinpercentage).to eq "44.8"
        expect(game_team_test.giveaways).to eq "17"
        expect(game_team_test.takeaways).to eq "7"
        
    end
    
end
