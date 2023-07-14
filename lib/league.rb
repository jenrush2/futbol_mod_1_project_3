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

    def add_season(season_to_add)
        @seasons << season_to_add
    end
end