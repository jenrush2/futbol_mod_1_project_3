require './lib/team.rb'
require 'rspec'
#require './data/teams_test.csv'
require 'CSV'

RSpec.describe Team do
    it 'exists' do
        array_of_team_hashes = []
        CSV.foreach('./data/teams_test.csv', :headers => true, :header_converters => :symbol) do |row|
            array_of_team_hashes << Hash[row.headers.zip(row.fields)]
            array_of_team_hashes
        end

        atlanta_united = Team.new(array_of_team_hashes[0])

        expect(atlanta_united).to be_an_instance_of Team

    end

    
end