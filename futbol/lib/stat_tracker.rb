require 'CSV'
require 'pry'
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
   
    def percentage_home_wins
        home_wins = @game_teams.count do |game_team_object|
                    (game_team_object.hoa == "home") and (game_team_object.result == "WIN")
                    end
        (home_wins/@games.count.to_f).round(2)
    end

    def percentage_visitor_wins
        visitor_wins = @game_teams.count do |game_team_object|
            (game_team_object.hoa == "away") and (game_team_object.result == "WIN")
            end
        (visitor_wins/@games.count.to_f).round(2)
    end

    def percentage_ties
        ties = @game_teams.count do |game_team_object|
            game_team_object.result == "TIE"
            end
        ((ties/2)/@games.count.to_f).round(2)
    end

    def count_of_games_by_season
        @games.reduce({}) do |games_by_season_hash, game_object|
            total_games_in_a_season = @games.count{|game| game.season == game_object.season}
            games_by_season_hash[game_object.season] = total_games_in_a_season
            games_by_season_hash
        end
    end

end