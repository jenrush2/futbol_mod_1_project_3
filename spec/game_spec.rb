require './lib/team.rb'
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

end