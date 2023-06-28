require 'CSV'

class StatTracker 
    attr_reader :games, :teams, :game_teams
    def initialize(args)
        @games = args[:games]
        @teams = args[:teams]
        @game_teams = args[:game_teams]
    end

    def self.from_csv(locations)
        StatTracker.new(locations)
    end
end