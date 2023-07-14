require './team'
require './game'

class Season
    attr_reader :season_years, :games

    def initialize(season_years)
        @season_years = season_years
        @games = []
    end

    def add_game(game_to_add)
        @games << game_to_add
    end
end