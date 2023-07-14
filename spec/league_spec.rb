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

end
