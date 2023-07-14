require './team'
require './game'

class Season
    attr_reader :season_years, :games

    def initialize(season_years)
        @season_years = season_years
        @games = []
    end

    def add_game(game_to_add)
        if game_to_add.season == season_years
            @games << game_to_add
        else
            p "Error: that game is from a different season. Please try again"
            @games 
        end
        @games 
    end
end