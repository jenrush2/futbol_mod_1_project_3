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

    def most_accurate_team(season)
        games_that_match_season = @games.find_all{|game| game.season == season}
        id_of_games_that_match_season = games_that_match_season.reduce([]) do |id_list, game|
            id_list << game.game_id
            id_list = id_list.uniq
        end

        game_teams_that_match_season = @game_teams.find_all{|game_team| id_of_games_that_match_season.include?(game_team.game_id)}

        teams_to_goal_shot_ratio = game_teams_that_match_season.reduce({}) do |teams_to_goal_shot_ratio_hash, game_team_object|
            
            if teams_to_goal_shot_ratio_hash[game_team_object.team_id] == nil
                number_of_shots_from_that_team = game_teams_that_match_season.reduce(0) {|sum_of_shots, game| if (game.team_id == game_team_object.team_id) then sum_of_shots + game.shots.to_f else sum_of_shots end} 
                number_of_goals_from_that_team = game_teams_that_match_season.reduce(0) {|sum_of_goals, game| if (game.team_id == game_team_object.team_id) then sum_of_goals + game.goals.to_f else sum_of_goals end} 
                teams_to_goal_shot_ratio_hash[game_team_object.team_id] = (number_of_goals_from_that_team/number_of_shots_from_that_team).round(3)
                teams_to_goal_shot_ratio_hash
            else
                teams_to_goal_shot_ratio_hash
            end
            
        end
        id_of_most_accurate_team = teams_to_goal_shot_ratio.key(teams_to_goal_shot_ratio.values.max)
        @teams.find{|team_object| team_object.team_id == id_of_most_accurate_team}.teamname
    end

    def least_accurate_team(season)
        games_that_match_season = @games.find_all{|game| game.season == season}
        id_of_games_that_match_season = games_that_match_season.reduce([]) do |id_list, game|
            id_list << game.game_id
            id_list = id_list.uniq
        end

        game_teams_that_match_season = @game_teams.find_all{|game_team| id_of_games_that_match_season.include?(game_team.game_id)}

        teams_to_goal_shot_ratio = game_teams_that_match_season.reduce({}) do |teams_to_goal_shot_ratio_hash, game_team_object|
            
            if teams_to_goal_shot_ratio_hash[game_team_object.team_id] == nil
                number_of_shots_from_that_team = game_teams_that_match_season.reduce(0) {|sum_of_shots, game| if (game.team_id == game_team_object.team_id) then sum_of_shots + game.shots.to_f else sum_of_shots end} 
                number_of_goals_from_that_team = game_teams_that_match_season.reduce(0) {|sum_of_goals, game| if (game.team_id == game_team_object.team_id) then sum_of_goals + game.goals.to_f else sum_of_goals end} 
                teams_to_goal_shot_ratio_hash[game_team_object.team_id] = (number_of_goals_from_that_team/number_of_shots_from_that_team).round(4)
                teams_to_goal_shot_ratio_hash
            else
                teams_to_goal_shot_ratio_hash
            end
            
        end
        id_of_most_accurate_team = teams_to_goal_shot_ratio.key(teams_to_goal_shot_ratio.values.min)
        @teams.find{|team_object| team_object.team_id == id_of_most_accurate_team}.teamname
    end

    def most_tackles(season)
        games_that_match_season = @games.find_all{|game| game.season == season}
        id_of_games_that_match_season = games_that_match_season.reduce([]) do |id_list, game|
            id_list << game.game_id
            id_list = id_list.uniq
        end

        game_teams_that_match_season = @game_teams.find_all{|game_team| id_of_games_that_match_season.include?(game_team.game_id)}

        teams_to_season_tackles = game_teams_that_match_season.reduce({}) do |teams_to_season_tackles_hash, game_team_object|
            
            if teams_to_season_tackles_hash[game_team_object.team_id] == nil
                number_of_tackles_from_that_team = game_teams_that_match_season.reduce(0) {|sum_of_tackles, game| if (game.team_id == game_team_object.team_id) then sum_of_tackles + game.tackles.to_f else sum_of_tackles end} 
                teams_to_season_tackles_hash[game_team_object.team_id] = number_of_tackles_from_that_team
                teams_to_season_tackles_hash
            else
                teams_to_season_tackles_hash
            end
            
        end
        id_of_most_tackles_team = teams_to_season_tackles.key(teams_to_season_tackles.values.max)
        @teams.find{|team_object| team_object.team_id == id_of_most_tackles_team}.teamname
    end

    def fewest_tackles(season)
        games_that_match_season = @games.find_all{|game| game.season == season}
        id_of_games_that_match_season = games_that_match_season.reduce([]) do |id_list, game|
            id_list << game.game_id
            id_list = id_list.uniq
        end

        game_teams_that_match_season = @game_teams.find_all{|game_team| id_of_games_that_match_season.include?(game_team.game_id)}

        teams_to_season_tackles = game_teams_that_match_season.reduce({}) do |teams_to_season_tackles_hash, game_team_object|
            
            if teams_to_season_tackles_hash[game_team_object.team_id] == nil
                number_of_tackles_from_that_team = game_teams_that_match_season.reduce(0) {|sum_of_tackles, game| if (game.team_id == game_team_object.team_id) then sum_of_tackles + game.tackles.to_f else sum_of_tackles end} 
                teams_to_season_tackles_hash[game_team_object.team_id] = number_of_tackles_from_that_team
                teams_to_season_tackles_hash
            else
                teams_to_season_tackles_hash
            end
            
        end
        id_of_most_tackles_team = teams_to_season_tackles.key(teams_to_season_tackles.values.min)
        @teams.find{|team_object| team_object.team_id == id_of_most_tackles_team}.teamname
    end

    def game_team_season(game_team_object)
        matching_game_object = @games.find{|game| game.game_id == game_team_object.game_id}
        matching_game_object.season
    end

    def best_season(given_team_id)
        game_teams_that_match_team_id = @game_teams.find_all{|game| game.team_id == given_team_id}

        season_to_win_percentage = game_teams_that_match_team_id.reduce({}) do |season_to_win_percentage_hash, game_team_object|
            
            if season_to_win_percentage_hash[self.game_team_season(game_team_object)] == nil
                #above: for this particular game team object, check the season. If that season is not already a key, continue below.
                number_of_games_from_that_season = game_teams_that_match_team_id.count{|game| self.game_team_season(game) == self.game_team_season(game_team_object)} 
                number_of_wins_from_that_season = game_teams_that_match_team_id.count{|game| self.game_team_season(game) == self.game_team_season(game_team_object) and game.result == "WIN"} 
                season_to_win_percentage_hash[self.game_team_season(game_team_object)] = (number_of_wins_from_that_season/number_of_games_from_that_season.to_f).round(4)
                season_to_win_percentage_hash
            else
                season_to_win_percentage_hash
            end
            
        end

        season_to_win_percentage.key(season_to_win_percentage.values.max)

    end

    def worst_season(given_team_id)
        game_teams_that_match_team_id = @game_teams.find_all{|game| game.team_id == given_team_id}

        season_to_win_percentage = game_teams_that_match_team_id.reduce({}) do |season_to_win_percentage_hash, game_team_object|
            
            if season_to_win_percentage_hash[self.game_team_season(game_team_object)] == nil
                #above: for this particular game team object, check the season. If that season is not already a key, continue below.
                number_of_games_from_that_season = game_teams_that_match_team_id.count{|game| self.game_team_season(game) == self.game_team_season(game_team_object)} 
                number_of_wins_from_that_season = game_teams_that_match_team_id.count{|game| self.game_team_season(game) == self.game_team_season(game_team_object) and game.result == "WIN"} 
                season_to_win_percentage_hash[self.game_team_season(game_team_object)] = (number_of_wins_from_that_season/number_of_games_from_that_season.to_f).round(4)
                season_to_win_percentage_hash
            else
                season_to_win_percentage_hash
            end
            
        end

        season_to_win_percentage.key(season_to_win_percentage.values.min)

    end

    def average_win_percentage(given_team_id)
        game_teams_that_match_team_id = @game_teams.find_all{|game| game.team_id == given_team_id}
        wins_for_this_team = game_teams_that_match_team_id.count{|game| game.result == "WIN"}
        total_games_for_this_team = game_teams_that_match_team_id.count
        avg_win_perc = (wins_for_this_team/total_games_for_this_team.to_f).round(2)
    end

    def most_goals_scored(given_team_id)
        game_teams_that_match_team_id = @game_teams.find_all{|game| game.team_id == given_team_id}
        list_of_goals = game_teams_that_match_team_id.reduce([]) {|array_of_goals, game_team_object| array_of_goals << game_team_object.goals.to_i}
        list_of_goals.max
    end

    def fewest_goals_scored(given_team_id)
        game_teams_that_match_team_id = @game_teams.find_all{|game| game.team_id == given_team_id}
        list_of_goals = game_teams_that_match_team_id.reduce([]) {|array_of_goals, game_team_object| array_of_goals << game_team_object.goals.to_i}
        list_of_goals.min
    end

    def favorite_opponent(given_team_id)
        game_teams_that_match_team_id = @game_teams.find_all{|game| game.team_id == given_team_id}

        list_of_game_ids = game_teams_that_match_team_id.reduce([]) {|list_of_game_ids, game_team_object| list_of_game_ids << game_team_object.game_id}
        game_teams_of_opponents = @game_teams.find_all{|game| list_of_game_ids.include?(game.game_id) and game.team_id != given_team_id}
        list_of_opponent_ids = game_teams_of_opponents.reduce([]) {|opponent_id_list, game_team_object| opponent_id_list << game_team_object.team_id}.uniq

        opponent_win_percentage_hash = list_of_opponent_ids.reduce({}) do |avg_win_perc_hash, opponent_id|
            game_teams_that_match_opponent_id = @game_teams.find_all{|game| game.team_id == opponent_id and list_of_game_ids.include?(game.game_id)}
            wins_for_this_team = game_teams_that_match_opponent_id.count{|game| game.result == "WIN" and list_of_game_ids.include?(game.game_id)}
            total_games_for_this_team = game_teams_that_match_opponent_id.count
            avg_win_perc = (wins_for_this_team/total_games_for_this_team.to_f).round(4)

            avg_win_perc_hash[opponent_id] = avg_win_perc
            avg_win_perc_hash
        end

        id_of_favorite_opponent = opponent_win_percentage_hash.key(opponent_win_percentage_hash.values.min)
        @teams.find{|team_object| team_object.team_id == id_of_favorite_opponent}.teamname

    end

    def rival(given_team_id)
        game_teams_that_match_team_id = @game_teams.find_all{|game| game.team_id == given_team_id}

        list_of_game_ids = game_teams_that_match_team_id.reduce([]) {|list_of_game_ids, game_team_object| list_of_game_ids << game_team_object.game_id}
        game_teams_of_opponents = @game_teams.find_all{|game| list_of_game_ids.include?(game.game_id) and game.team_id != given_team_id}
        list_of_opponent_ids = game_teams_of_opponents.reduce([]) {|opponent_id_list, game_team_object| opponent_id_list << game_team_object.team_id}.uniq

        opponent_win_percentage_hash = list_of_opponent_ids.reduce({}) do |avg_win_perc_hash, opponent_id|
            game_teams_that_match_opponent_id = @game_teams.find_all{|game| game.team_id == opponent_id and list_of_game_ids.include?(game.game_id)}
            wins_for_this_team = game_teams_that_match_opponent_id.count{|game| game.result == "WIN" and list_of_game_ids.include?(game.game_id)}
            total_games_for_this_team = game_teams_that_match_opponent_id.count
            avg_win_perc = (wins_for_this_team/total_games_for_this_team.to_f).round(4)

            avg_win_perc_hash[opponent_id] = avg_win_perc
            avg_win_perc_hash
        end

        id_of_rival = opponent_win_percentage_hash.key(opponent_win_percentage_hash.values.max)
        @teams.find{|team_object| team_object.team_id == id_of_rival}.teamname

    end

    def biggest_team_blowout(given_team_id)
        game_teams_array_of_wins = @game_teams.find_all{|game| game.team_id == given_team_id and game.result == "WIN"}
        array_of_game_ids_for_wins = game_teams_array_of_wins.reduce([]) {|list_of_game_ids, game_team_object| list_of_game_ids << game_team_object.game_id}
        array_of_score_difference = @games.reduce([]) do |new_array, game_object|
            if array_of_game_ids_for_wins.include?(game_object.game_id) 
                new_array << (game_object.away_goals.to_i - game_object.home_goals.to_i).abs
                new_array
            else
                new_array
            end
            new_array
        end

        array_of_score_difference.max

    end

    def worst_loss(given_team_id)
        game_teams_array_of_losses = @game_teams.find_all{|game| game.team_id == given_team_id and game.result == "LOSS"}
        array_of_game_ids_for_losses = game_teams_array_of_losses.reduce([]) {|list_of_game_ids, game_team_object| list_of_game_ids << game_team_object.game_id}
        array_of_score_difference = @games.reduce([]) do |new_array, game_object|
            if array_of_game_ids_for_losses.include?(game_object.game_id) 
                new_array << (game_object.away_goals.to_i - game_object.home_goals.to_i).abs
                new_array
            else
                new_array
            end
            new_array
        end

        array_of_score_difference.max
    end

    def head_to_head(given_team_id)
        game_teams_that_match_team_id = @game_teams.find_all{|game| game.team_id == given_team_id}
        list_of_game_ids = game_teams_that_match_team_id.reduce([]) {|list_of_game_ids, game_team_object| list_of_game_ids << game_team_object.game_id}
        game_teams_of_opponents = @game_teams.find_all{|game| list_of_game_ids.include?(game.game_id) and game.team_id != given_team_id}
        list_of_opponent_ids = game_teams_of_opponents.reduce([]) {|opponent_id_list, game_team_object| opponent_id_list << game_team_object.team_id}.uniq

        opponent_win_percentage_hash = list_of_opponent_ids.reduce({}) do |avg_win_perc_hash, opponent_id|
            game_teams_that_match_opponent_id = @game_teams.find_all{|game| game.team_id == opponent_id and list_of_game_ids.include?(game.game_id)}
            wins_for_this_team = game_teams_that_match_opponent_id.count{|game| game.result == "WIN" and list_of_game_ids.include?(game.game_id)}
            total_games_for_this_team = game_teams_that_match_opponent_id.count
            avg_win_perc = (wins_for_this_team/total_games_for_this_team.to_f).round(4)

            avg_win_perc_hash[@teams.find{|team_object| team_object.team_id == opponent_id}.teamname] = avg_win_perc
            avg_win_perc_hash
        end

        opponent_win_percentage_hash

    end

    def game_team_type(game_team_object)
        matching_game_object = @games.find_all{|game| game.game_id == game_team_object.game_id}
        matching_game_object[0].type 
    end

    def list_postseason_games(given_team_id, season)
        game_teams_that_match_team_id = @game_teams.find_all{|game| game.team_id == given_team_id}
        #for given team
        list_of_game_ids = game_teams_that_match_team_id.reduce([]) {|list_of_game_ids, game_team_object| list_of_game_ids << game_team_object.game_id}

        game_teams_for_one_season = game_teams_that_match_team_id.find_all{|game_team| self.game_team_season(game_team) == season}

        postseason_games_for_given_season = game_teams_for_one_season.find_all{|game_team_object| game_team_type(game_team_object) == "Postseason"}
        p postseason_games_for_given_season
        postseason_games_for_given_season
    end


    
    def seasonal_summary(given_team_id)
        #split by team id
        game_teams_that_match_team_id = @game_teams.find_all{|game| game.team_id == given_team_id}
        list_of_game_ids = game_teams_that_match_team_id.reduce([]) {|list_of_game_ids, game_team_object| list_of_game_ids << game_team_object.game_id}

        #split that by season
        seasonal_summary = game_teams_that_match_team_id.reduce({}) do |seasonal_summary_hash, game_team_object|
            if seasonal_summary_hash[self.game_team_season(game_team_object)] == nil
                game_teams_for_one_season = game_teams_that_match_team_id.find_all{|game_team| self.game_team_season(game_team) == self.game_team_season(game_team_object)}
                game_teams_for_one_season_postseason = game_teams_for_one_season.find_all{|game| list_of_game_ids.include?(game.game_id) and self.game_team_type(game) == "Postseason"}
                game_teams_for_one_season_regular_season = game_teams_for_one_season.find_all{|game| list_of_game_ids.include?(game.game_id) and self.game_team_type(game) == "Regular Season"}
                game_ids_for_one_season_postseason = game_teams_for_one_season_postseason.reduce([]){|id_list, game_team_object| id_list << game_team_object.game_id}
                game_ids_for_one_season_regular_season = game_teams_for_one_season_regular_season.reduce([]){|id_list, game_team_object| id_list << game_team_object.game_id}

                #win percentage variables needed
                one_season_postseason_wins_count = game_teams_for_one_season_postseason.count{|game| game.result == "WIN"}
                one_season_postseason_total_games_count = game_teams_for_one_season_postseason.count
                one_season_regular_season_wins_count = game_teams_for_one_season_regular_season.count{|game| game.result == "WIN"}
                one_season_regular_season_total_games_count = game_teams_for_one_season_regular_season.count
                #win percentagle calculations
                win_percentage_one_season_postseason = (one_season_postseason_wins_count/one_season_postseason_total_games_count.to_f).round(4)
                win_percentage_one_season_regular_season = (one_season_regular_season_wins_count/one_season_regular_season_total_games_count.to_f).round(4)

                #total goals scored calculations
                total_goals_one_season_postseason = game_teams_for_one_season_postseason.reduce(0){|count, game_team_object| count + game_team_object.goals.to_i}
                total_goals_one_season_regular_season = game_teams_for_one_season_regular_season.reduce(0){|count, game_team_object| count + game_team_object.goals.to_i}
               
                #total goals against needed variables
                game_teams_of_opponents_one_season_postseason = @game_teams.find_all{|game| game_ids_for_one_season_postseason.include?(game.game_id) and game.team_id != given_team_id}
                game_teams_of_opponents_one_season_regular_season = @game_teams.find_all{|game| game_ids_for_one_season_regular_season.include?(game.game_id) and game.team_id != given_team_id}

                #total goals against calculations
                total_goals_against_one_season_postseason = game_teams_of_opponents_one_season_postseason.reduce(0){|count, game_team_object| count + game_team_object.goals.to_i}
                total_goals_against_one_season_regular_season = game_teams_of_opponents_one_season_regular_season.reduce(0){|count, game_team_object| count + game_team_object.goals.to_i}

                #average goals scored calculations
                average_goals_one_season_postseason = (total_goals_one_season_postseason/one_season_postseason_total_games_count.to_f).round(4)
                averalge_goals_one_season_regular_season = (total_goals_one_season_regular_season/one_season_regular_season_total_games_count.to_f).round(4)

                #averagle goals against calculations
                average_goals_against_one_season_postseason = (total_goals_against_one_season_postseason/one_season_postseason_total_games_count.to_f).round(4)
                average_goals_against_one_season_regular_season = (total_goals_against_one_season_regular_season/one_season_regular_season_total_games_count.to_f).round(4)
                
                if one_season_postseason_total_games_count == 0
                    postseason_hash = "Did not participate in postseason."
                else
                    postseason_hash = 
                    {
                        :win_percentage => win_percentage_one_season_postseason,
                        :total_goals_scored => total_goals_one_season_postseason,
                        :total_goals_against => total_goals_against_one_season_postseason,
                        :average_goals_scored => average_goals_one_season_postseason,
                        :average_goals_against => average_goals_against_one_season_postseason
                    }
                end

                regular_season_hash = {
                    :win_percentage => win_percentage_one_season_regular_season,
                    :total_goals_scored => total_goals_one_season_regular_season,
                    :total_goals_against => total_goals_against_one_season_regular_season,
                    :average_goals_scored => averalge_goals_one_season_regular_season,
                    :average_goals_against => average_goals_against_one_season_regular_season
                }

                post_reg_hash = {
                    :regular_season => regular_season_hash,
                    :postseason => postseason_hash
                }

                #create final hash
                seasonal_summary_hash[self.game_team_season(game_team_object)] = post_reg_hash
                
                seasonal_summary_hash

            else
                seasonal_summary_hash
            end


        end

        seasonal_summary = seasonal_summary.sort_by{|key,val| key}.to_h
        seasonal_summary      
    end


end