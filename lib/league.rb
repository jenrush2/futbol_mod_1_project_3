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
end