require './team.rb'
require './game.rb'
require './season.rb'

class League
    attr_reader :name,
                :teams,
                :seasons
    
    def initialize(name)
        @name = name
        @teams = []
        @seasons = []
    end

    def add_team(team_to_add)
        @teams << team_to_add
    end
end