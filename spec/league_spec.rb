require './lib/team.rb'
require './lib/game.rb'
require './lib/season.rb'
require './lib/league.rb'
require 'rspec'
require 'CSV'

RSpec.describe League do
    it 'exists' do
        mls_league = League.new("Major League Soccer")

        expect(mls_league).to be_an_instance_of League
    end

    it 'has attributes' do
        mls_league = League.new("Major League Soccer")

        expect(mls_league.name).to eq "Major League Soccer"
        expect(mls_league.teams).to eq([])
        expect(mls_league.seasons).to eq([])
    end

    it 'can add teams' do
        mls_league = League.new("Major League Soccer")

        array_of_team_hashes = []
        CSV.foreach('./data/teams_test.csv', :headers => true, :header_converters => :symbol) do |row|
            array_of_team_hashes << Hash[row.headers.zip(row.fields)]
            array_of_team_hashes
        end

        atlanta_united = Team.new(array_of_team_hashes[0])
        chicago_fire = Team.new(array_of_team_hashes[1])
        fc_cincinnati = Team.new(array_of_team_hashes[2])
        dc_united = Team.new(array_of_team_hashes[3])
        fc_dallas = Team.new(array_of_team_hashes[4])


        mls_league.add_team(atlanta_united)
        mls_league.add_team(chicago_fire)
        mls_league.add_team(fc_cincinnati)
        mls_league.add_team(dc_united)
        mls_league.add_team(fc_dallas)

        expect(mls_league.teams).to be_an_instance_of Array 
        expect(mls_league.teams[0]).to be_an_instance_of Team 
        expect(mls_league.teams).to eq([atlanta_united, chicago_fire, fc_cincinnati, dc_united, fc_dallas])
    end

    it 'can add seasons' do
        mls_league = League.new("Major League Soccer")

        season_2012_2013 = Season.new("20122013")
        
        array_of_games_hashes = []
        CSV.foreach('./data/games_test.csv', :headers => true, :header_converters => :symbol) do |row|
            array_of_games_hashes << Hash[row.headers.zip(row.fields)]
            array_of_games_hashes
        end

        test_game_1 = Game.new(array_of_games_hashes[0])
        test_game_2 = Game.new(array_of_games_hashes[1])
        test_game_3 = Game.new(array_of_games_hashes[2])


        season_2012_2013.add_game(test_game_1)
        season_2012_2013.add_game(test_game_2)
        season_2012_2013.add_game(test_game_3)

        mls_league.add_season(season_2012_2013)

        expect(mls_league.seasons).to be_an_instance_of Array 
        expect(mls_league.seasons[0]).to be_an_instance_of Season 
        expect(mls_league.seasons[0]).to eq(season_2012_2013)
        expect(mls_league.seasons[0].games[0]).to eq(test_game_1)
        
    end

end
