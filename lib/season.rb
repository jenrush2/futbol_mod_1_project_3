require './team'
require './game'

class Season
    attr_reader :season_years

    def initialize(season_years)
        @season_years = season_years
        @games = []
    end
end