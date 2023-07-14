require './lib/team.rb'
require './lib/game.rb'
require './lib/season.rb'
require 'rspec'
require 'CSV'

RSpec.describe Season do
    it 'exists' do
        season_2012_2013 = Season.new("20122013")

        expect(season_2012_2013).to be_an_instance_of Season
    end
end