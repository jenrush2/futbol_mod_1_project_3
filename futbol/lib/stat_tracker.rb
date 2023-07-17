require 'CSV'
require_relative './team.rb'
require_relative './game.rb'
require_relative './game_team.rb'

class StatTracker 
    attr_reader :games, :teams, :game_teams
    def initialize(args)
        @games = array_of_games_objects = []
                CSV.foreach(args[:games], :headers => true, :header_converters => :symbol) do |row|
                    array_of_games_objects << Game.new(Hash[row.headers.zip(row.fields)])
                    array_of_games_objects
                end
        @teams = array_of_teams_objects = []
                CSV.foreach(args[:teams], :headers => true, :header_converters => :symbol) do |row|
                    array_of_teams_objects << Team.new(Hash[row.headers.zip(row.fields)])
                    array_of_teams_objects
                end
        @game_teams = array_of_game_team_objects = []
                CSV.foreach(args[:game_teams], :headers => true, :header_converters => :symbol) do |row|
                    array_of_game_team_objects << Game_Team.new(Hash[row.headers.zip(row.fields)])
                    array_of_game_team_objects
                end
    end

    def self.from_csv(locations)
        StatTracker.new(locations)
    end
    
    def count_of_teams
        @teams.count 
    end

    def highest_total_score
        all_total_scores = @games.reduce([]) do |new_array, game_object|
            new_array << game_object.home_goals.to_i + game_object.away_goals.to_i 
        end
        all_total_scores.max
    end

    def lowest_total_score
        all_total_scores = @games.reduce([]) do |new_array, game_object|
            new_array << game_object.home_goals.to_i + game_object.away_goals.to_i 
        end
        all_total_scores.min
    end
        

end