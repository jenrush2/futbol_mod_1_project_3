class Game_Team
    attr_reader :game_id,
                :team_id,
                :hoa,
                :result,
                :settled_in,
                :head_coach,
                :goals,
                :shots,
                :tackles,
                :pim,
                :powerplayopportunities,
                :powerplaygoals,
                :faceoffwinpercentage,
                :giveaways,
                :takeaways

    def initialize(args)
        @game_id = args[:game_id]
        @team_id = args[:team_id]
        @hoa = args[:hoa]
        @result = args[:result]
        @settled_in = args[:settled_in]
        @head_coach = args[:head_coach]
        @goals = args[:goals]
        @shots = args[:shots]
        @tackles = args[:tackles]
        @pim = args[:pim]
        @powerplayopportunities = args[:powerplayopportunities]
        @powerplaygoals = args[:powerplaygoals]
        @faceoffwinpercentage = args[:faceoffwinpercentage]
        @giveaways = args[:giveaways]
        @takeaways = args[:takeaways]
    end

end
