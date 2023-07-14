# Futbol

Starter repository for the [Turing School](https://turing.io/) Futbol project.

# Notes for Jen:
The instructions say that: Each of the methods described below (on instructions page for iteration 2 https://backend.turing.edu/module1/projects/futbol_pd/iterations/file_io_stats) should be implemented as instance methods on StatTracker in order for the spec harness to work properly.



    Team class:
        attributes: everything in the headers for teams csv file?
            team_id,franchiseId,teamName,abbreviation,Stadium,link

        methods: list home wins in a season, list home losses in a season, list away wins in a season, list away losses in a season, season shots, season goals, season tackles, average goals per game in a season
    
    Game class:
        attributes: everything in the headers for games csv? 
            game:
                game_id,season,type,date_time,away_team_id,home_team_id,away_goals,home_goals,venue,venue_link

        methods: split up all "game by team" stats into home and visitor stats?
            game by team:
                game_id,team_id,HoA,result,settled_in,head_coach,goals,shots,tackles,pim,powerPlayOpportunities,powerPlayGoals,faceOffWinPercentage,giveaways,takeaways

    League class:
        attributes: name, teams (array of Team classes?)
        methods: (These are all "across all seasons") count_of_teams, best_offense, worst_offense, highest_scoring_visitor, highest_scoring_home_team, lowest_scoring_visitor, lowest_scoring_home_team
    
    
    Season class:
        attributes: season_name (two year split in header), games (array of Game classes)
        methods: winningest_coach, worst_coach, most_accurate_team, least_accurate_team, most_tackles, fewest_tackles
    

    Methods I'm iffy about placement because they are all under "Game Statistics" in the instructions:
        average_goals_per_game (across all seasons) --> League or only contained in StatTracker?
        average_goals_by_season (avg per game for each season) --> League or only contained in StatTracker?
        count_of_games_by_season (seasons to counts of games) --> League or only contained in StatTracker?
        percentage_ties (assumed to be across all seasons) --> League or only contained in StatTracker?
        percentage_visitor_wins (assumed to be across all seasons) --> League or only contained in StatTracker?
        percentage_home_wins (assumed to be across all seasons) --> League or only contained in StatTracker?
        lowest_total_score (assumed to be across all seasons) --> League or only contained in StatTracker?
        highest_total_score (assumed to be across all seasons) --> League or only contained in StatTracker?