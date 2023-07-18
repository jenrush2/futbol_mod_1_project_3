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

    def average_goals_per_game
        goals_per_game = @games.reduce([]) do |goals, game_object|
            goals << game_object.home_goals.to_i + game_object.away_goals.to_i 
        end

        (goals_per_game.sum.to_f/@games.count).round(2)
    end

    def average_goals_by_season

        @games.reduce({}) do |goals_by_season_hash, game_object|
            
            goals_in_a_season =  
                (@games.reduce(0) do |sum, game|
                    if game.season == game_object.season
                        sum + (game.home_goals.to_i + game.away_goals.to_i)
                    else
                        sum
                    end
                end)
                
            average_goals_in_a_season = (goals_in_a_season.to_f/self.count_of_games_by_season[game_object.season]).round(2)
            goals_by_season_hash[game_object.season] = average_goals_in_a_season
            goals_by_season_hash

        end
    end

    def best_offense
        teams_and_goals_hash = @game_teams.reduce({}) do |new_hash, game_team_object|
            new_hash[game_team_object.team_id] = @game_teams.reduce(0) do |sum, object| 
                        if object.team_id == game_team_object.team_id 
                            sum + object.goals.to_i
                        else
                            sum
                        end
                    end
            new_hash
        end

        teams_and_goal_avg_hash = teams_and_goals_hash.reduce({}) do |new_hash, team_goal_pair|
            new_hash[team_goal_pair[0]] = (team_goal_pair[1].to_f/(@game_teams.count{|game| game.team_id == team_goal_pair[0]})).round(2)
            new_hash
        end

        awesome_team_id = teams_and_goal_avg_hash.key(teams_and_goal_avg_hash.values.max)
        
        @teams.find{|team_object| team_object.team_id == awesome_team_id}.teamname

    end

    def worst_offense
        teams_and_goals_hash = @game_teams.reduce({}) do |new_hash, game_team_object|
            new_hash[game_team_object.team_id] = @game_teams.reduce(0) do |sum, object| 
                        if object.team_id == game_team_object.team_id 
                            sum + object.goals.to_i
                        else
                            sum
                        end
                    end
            new_hash
        end

        teams_and_goal_avg_hash = teams_and_goals_hash.reduce({}) do |new_hash, team_goal_pair|
            new_hash[team_goal_pair[0]] = (team_goal_pair[1].to_f/(@game_teams.count{|game| game.team_id == team_goal_pair[0]})).round(2)
            new_hash
        end

        terrible_team_id = teams_and_goal_avg_hash.key(teams_and_goal_avg_hash.values.min)
        
        @teams.find{|team_object| team_object.team_id == terrible_team_id}.teamname
    end

    def highest_scoring_visitor
        teams_and_goals_hash_away_only = @game_teams.reduce({}) do |new_hash, game_team_object|
            new_hash[game_team_object.team_id] = @game_teams.reduce(0) do |sum, object| 
                        if (object.team_id == game_team_object.team_id) and (object.hoa == "away") 
                            sum + object.goals.to_i
                        else
                            sum
                        end
                    end
            new_hash
        end

        teams_and_goal_avg_hash = teams_and_goals_hash_away_only.reduce({}) do |new_hash, team_goal_pair|
            new_hash[team_goal_pair[0]] = (team_goal_pair[1].to_f/(@game_teams.count{|game| game.team_id == team_goal_pair[0]})).round(2)
            new_hash
        end

        awesome_team_id = teams_and_goal_avg_hash.key(teams_and_goal_avg_hash.values.max)
        
        @teams.find{|team_object| team_object.team_id == awesome_team_id}.teamname
    end

    def highest_scoring_home_team
        teams_and_goals_hash_home_only = @game_teams.reduce({}) do |new_hash, game_team_object|
            new_hash[game_team_object.team_id] = @game_teams.reduce(0) do |sum, object| 
                        if (object.team_id == game_team_object.team_id) and (object.hoa == "home") 
                            sum + object.goals.to_i
                        else
                            sum
                        end
                    end
            new_hash
        end

        teams_and_goal_avg_hash = teams_and_goals_hash_home_only.reduce({}) do |new_hash, team_goal_pair|
            new_hash[team_goal_pair[0]] = (team_goal_pair[1].to_f/(@game_teams.count{|game| game.team_id == team_goal_pair[0]})).round(2)
            new_hash
        end

        awesome_team_id = teams_and_goal_avg_hash.key(teams_and_goal_avg_hash.values.max)
        
        @teams.find{|team_object| team_object.team_id == awesome_team_id}.teamname
    end

    def lowest_scoring_visitor
        teams_and_goals_hash_away_only = @game_teams.reduce({}) do |new_hash, game_team_object|
            new_hash[game_team_object.team_id] = @game_teams.reduce(0) do |sum, object| 
                        if (object.team_id == game_team_object.team_id) and (object.hoa == "away") 
                            sum + object.goals.to_i
                        else
                            sum
                        end
                    end
            new_hash
        end

        teams_and_goal_avg_hash = teams_and_goals_hash_away_only.reduce({}) do |new_hash, team_goal_pair|
            new_hash[team_goal_pair[0]] = (team_goal_pair[1].to_f/(@game_teams.count{|game| game.team_id == team_goal_pair[0]})).round(2)
            new_hash
        end

        terrible_team_id = teams_and_goal_avg_hash.key(teams_and_goal_avg_hash.values.min)
        
        @teams.find{|team_object| team_object.team_id == terrible_team_id}.teamname
    end

    def lowest_scoring_home_team
        teams_and_goals_hash_home_only = @game_teams.reduce({}) do |new_hash, game_team_object|
            new_hash[game_team_object.team_id] = @game_teams.reduce(0) do |sum, object| 
                        if (object.team_id == game_team_object.team_id) and (object.hoa == "home") 
                            sum + object.goals.to_i
                        else
                            sum
                        end
                    end
            new_hash
        end

        teams_and_goal_avg_hash = teams_and_goals_hash_home_only.reduce({}) do |new_hash, team_goal_pair|
            new_hash[team_goal_pair[0]] = (team_goal_pair[1].to_f/(@game_teams.count{|game| game.team_id == team_goal_pair[0]})).round(2)
            new_hash
        end

        terrible_team_id = teams_and_goal_avg_hash.key(teams_and_goal_avg_hash.values.min)
        
        @teams.find{|team_object| team_object.team_id == terrible_team_id}.teamname
    end

    def team_info(id_of_team)
        @teams.reduce({}) do |hash_of_team_info, team_object|
            if team_object.team_id == id_of_team
                hash_of_team_info["team_id"] = team_object.team_id
                hash_of_team_info["franchise_id"] = team_object.franchiseid
                hash_of_team_info["team_name"] = team_object.teamname
                hash_of_team_info["abbreviation"] = team_object.abbreviation
                hash_of_team_info["link"] = team_object.link
                hash_of_team_info
            else
                hash_of_team_info
            end
        end
    end

    def winningest_coach(season)
        games_that_match_season = @games.find_all{|game| game.season == season}
        id_of_games_that_match_season = games_that_match_season.reduce([]) do |id_list, game|
            id_list << game.game_id
            id_list = id_list.uniq
        end

        game_teams_that_match_season = @game_teams.find_all{|game_team| id_of_games_that_match_season.include?(game_team.game_id)}

        coaches_to_season_wins = game_teams_that_match_season.reduce({}) do |coaches_to_wins_hash, game_team_object|
            
            if game_team_object.result == "WIN" and coaches_to_wins_hash[game_team_object.head_coach] == nil
                number_of_games_from_that_coach = game_teams_that_match_season.count{|game| game.head_coach == game_team_object.head_coach} 
                number_of_wins_from_that_coach = game_teams_that_match_season.count{|game| (game.head_coach == game_team_object.head_coach) and game.result == "WIN"} 
                coaches_to_wins_hash[game_team_object.head_coach] = number_of_wins_from_that_coach/number_of_games_from_that_coach.to_f
                coaches_to_wins_hash
            else
                coaches_to_wins_hash
            end
            
        end

        coaches_to_season_wins.key(coaches_to_season_wins.values.max)

    end

    def worst_coach(season)
        games_that_match_season = @games.find_all{|game| game.season == season}
        id_of_games_that_match_season = games_that_match_season.reduce([]) do |id_list, game|
            id_list << game.game_id
            id_list = id_list.uniq
        end

        game_teams_that_match_season = @game_teams.find_all{|game_team| id_of_games_that_match_season.include?(game_team.game_id)}

        coaches_to_season_wins = game_teams_that_match_season.reduce({}) do |coaches_to_wins_hash, game_team_object|
            
            if coaches_to_wins_hash[game_team_object.head_coach] == nil
                number_of_games_from_that_coach = game_teams_that_match_season.count{|game| game.head_coach == game_team_object.head_coach} 
                number_of_wins_from_that_coach = game_teams_that_match_season.count{|game| (game.head_coach == game_team_object.head_coach) and game.result == "WIN"} 
                coaches_to_wins_hash[game_team_object.head_coach] = (number_of_wins_from_that_coach/number_of_games_from_that_coach.to_f).round(2)
                coaches_to_wins_hash
            else
                coaches_to_wins_hash
            end
            
        end
        coaches_to_season_wins.key(coaches_to_season_wins.values.min)

    end


end