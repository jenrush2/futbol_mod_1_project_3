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

    it 'has attributes' do
        array_of_team_hashes = []
        CSV.foreach('./data/teams_test.csv', :headers => true, :header_converters => :symbol) do |row|
            array_of_team_hashes << Hash[row.headers.zip(row.fields)]
            array_of_team_hashes
        end

        atlanta_united = Team.new(array_of_team_hashes[0])

        expect(atlanta_united.team_id).to eq "1"
        expect(atlanta_united.franchiseid).to eq "23"
        expect(atlanta_united.teamname).to eq "Atlanta United"
        expect(atlanta_united.abbreviation).to eq "ATL"
        expect(atlanta_united.stadium).to eq "Mercedes-Benz Stadium"
        expect(atlanta_united.link).to eq "/api/v1/teams/1"
    end


end